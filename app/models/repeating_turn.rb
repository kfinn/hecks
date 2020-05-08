class RepeatingTurn < Turn
    belongs_to :roll, optional: true
    belongs_to :robber_moved_to_territory, class_name: 'Territory', optional: true
    belongs_to :robbed_player, class_name: 'Player', optional: true

    has_many :discard_requirements, inverse_of: :turn, foreign_key: :turn_id

    has_many :player_offer_agreements, through: :player_offers

    validates :roll, presence: { if: :ended? }
    validate :robber_move_columns_must_be_mutually_present
    validate :robbed_player_must_occupy_robber_moved_to_territory

    def description
        if roll.blank?
            'roll the dice'
        elsif needs_robber_move?
            'move the robber'
        elsif !all_discard_requirements_met?
            'wait for everyone to discard their excess cards'
        elsif needs_robbed_player?
            'select a player to rob'
        else
            'take an action or end the turn'
        end
    end

    def actions
        ActionCollection.new.tap do |action_collection|
            if can_create_production_roll?
                action_collection.dice_actions << 'ProductionRoll#create'
            elsif needs_robber_move?
                game.territories.without_robber.each do |territory|
                    action_collection.territory_actions[territory] << 'RobberMove#create'
                end
            elsif needs_robbed_player?
                robbable_players.each do |player|
                    action_collection.player_actions[player] << 'Robbery#create'
                end
            elsif can_end_turn?
                action_collection.dice_actions << 'RepeatingTurnEnds#create'
            end

            if can_purchase_settlement?
                game.corners.available_for_settlement.reachable_by(player).each do |corner|
                    action_collection.corner_actions[corner] << 'SettlementPurchase#create'
                end
            end

            if can_purchase_road?
                game.borders.available_for_road.reachable_by(player).each do |border|
                    action_collection.border_actions[border] << 'RoadPurchase#create'
                end
            end

            if can_purchase_city_upgrade?
                game.corners.available_for_city_upgrade_by(player).each do |corner|
                    action_collection.corner_actions[corner] << 'CityUpgradePurchase#create'
                end
            end

            if can_purchase_development_card?
                action_collection.new_development_card_actions << 'DevelopmentCardPurchase#create'
            end

            if can_trade?
                player.bank_offers.each do |bank_offer|
                    action_collection.bank_offer_actions[bank_offer] << 'BankTrade#create' if bank_offer.affordable?
                end
                if player.total_resource_cards_count > 0
                    action_collection.new_player_offer_actions << 'PlayerOffer#create'
                end
                player_offer_agreements.includes(:player_offer).each do |player_offer_agreement|
                    action_collection.player_offer_agreement_actions[player_offer_agreement] << 'PlayerTrade#create' if player_offer_agreement.affordable?
                end
            end

            player.active_development_cards.each do |development_card|
                development_card.development_card_actions(self).each do |action|
                    action_collection.development_card_actions[development_card] << action
                end
            end
        end
    end

    def can_create_production_roll?
        roll.nil? && current?
    end

    def roll_actions_completed?
        if roll.blank?
            false
        elsif roll.value == 7
            robber_moved? &&
                (player_robbed? || no_players_to_rob?) &&
                all_discard_requirements_met?
        else
            true
        end
    end

    def all_discard_requirements_met?
        discard_requirements.pending.empty?
    end

    def needs_robber_move?
        roll.present? && roll.value == 7 && !robber_moved?
    end
    alias can_move_robber? needs_robber_move?

    def needs_robbed_player?
        robber_moved? && players_to_rob? && !player_robbed? && all_discard_requirements_met?
    end

    def can_rob_player?(player_to_rob)
        needs_robbed_player? && robbable_players.include?(player_to_rob)
    end

    def player_robbed?
        robbed_player.present?
    end

    def robbable_players
        (robber_moved_to_territory&.players&.where&.not(id: player.id)) || []
    end

    def no_players_to_rob?
        robber_moved_to_territory && robbable_players.empty?
    end

    def players_to_rob?
        !no_players_to_rob?
    end

    def robber_moved?
        robber_moved_at.present?
    end

    def roll_completed?
        roll.present? && roll_actions_completed?
    end

    def can_end_turn?
        roll_completed? && current?
    end

    def can_purchase_settlement?
        can_purchase? &&
            player.brick_cards_count >= 1 &&
            player.grain_cards_count >= 1 &&
            player.lumber_cards_count >= 1 &&
            player.wool_cards_count >= 1
    end

    def can_purchase_road?
        can_purchase? &&
            player.brick_cards_count >= 1 &&
            player.lumber_cards_count >= 1
    end

    def can_purchase_city_upgrade?
        can_purchase? &&
            player.grain_cards_count >= 2 &&
            player.ore_cards_count >= 3
    end

    def can_purchase_development_card?
        can_purchase? &&
            player.grain_cards_count >= 1 &&
            player.ore_cards_count >= 1 &&
            player.wool_cards_count >= 1
    end

    def ended?
        ended_at.present?
    end

    def active?
        !ended?
    end

    def can_purchase?
        current? && active? && roll_completed?
    end
    alias can_trade? can_purchase?
    alias can_play_development_cards? can_purchase?

    def build_next_turn
        RepeatingTurn.new(game: game, player: player.next_player)
    end

    private

    def robber_move_columns_must_be_mutually_present
        if robber_moved_at.present? && robber_moved_to_territory.blank?
            errors[:robber_moved_to_territory] << "can't be blank"
        elsif robber_moved_to_territory.present? && robber_moved_at.blank?
            errors[:robber_moved_at] << "can't be blank"
        end
    end

    def robbed_player_must_occupy_robber_moved_to_territory
        return unless robber_moved_to_territory.present? && robbed_player.present?
        errors[:robbed_player] << 'cannot rob this player' unless robbable_players.include? robbed_player
    end
end
