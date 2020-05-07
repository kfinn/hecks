class RepeatingTurn < Turn
    belongs_to :roll, optional: true
    belongs_to :robber_moved_to_territory, class_name: 'Territory', optional: true

    validates :roll, presence: { if: :ended? }
    validate :robber_move_columns_must_be_mutually_present

    def description
        if roll.blank?
            'roll the dice'
        elsif needs_robber_move?
            'move the robber'
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

            if can_trade?
                player.bank_offers.each do |bank_offer|
                    action_collection.bank_offer_actions[bank_offer] << 'BankTrade#create' if bank_offer.affordable?
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
            robber_moved?
        else
            true
        end
    end

    def needs_robber_move?
        roll.present? && roll.value == 7 && !robber_moved?
    end
    alias can_move_robber? needs_robber_move?

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
end
