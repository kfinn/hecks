class RepeatingTurn < Turn
    belongs_to :roll, optional: true

    has_many :discard_requirements, inverse_of: :turn, foreign_key: :turn_id

    has_many :robber_move_requirements, inverse_of: :turn, foreign_key: :turn_id
    has_one(
        :latest_robber_move_requirement,
        -> { order(created_at: :desc) },
        inverse_of: :turn,
        foreign_key: :turn_id,
        class_name: 'RobberMoveRequirement'
    )

    has_many(
        :played_development_cards,
        class_name: 'DevelopmentCard',
        inverse_of: :played_during_turn,
        foreign_key: :played_during_turn_id
    )

    has_many(
        :incomplete_road_building_card_plays,
        -> { incomplete },
        through: :played_development_cards,
        source: :road_building_card_play
    )

    has_many :player_offer_responses, through: :player_offers

    validates :roll, presence: { if: :ended? }

    delegate :can_rob_player?, to: :latest_robber_move_requirement, allow_nil: true

    def description
        if needs_robber_move?
            'move the robber'
        elsif needs_robbed_player?
            'select a player to rob'
        elsif roll.blank?
            'roll the dice'
        elsif !all_discard_requirements_met?
            'wait for everyone to discard their excess cards'
        elsif any_incomplete_road_building_card_plays?
            incomplete_road_building_card_plays.first.turn_description
        else
            'take an action or end the turn'
        end
    end

    def actions
        return [] unless current?

        ActionCollection.new.tap do |action_collection|
            if needs_robber_move?
                game.territories.without_robber.each do |territory|
                    action_collection.territory_actions[territory] << 'RobberMove#create'
                end
            end

            if needs_robbed_player?
                latest_robber_move_requirement.robbable_players.each do |player|
                    action_collection.player_actions[player] << 'Robbery#create'
                end
            end

            if can_create_production_roll?
                action_collection.dice_actions << 'ProductionRoll#create'
            end

            if can_end_turn?
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
                player_offer_responses.includes(:player_offer).each do |player_offer_response|
                    action_collection.player_offer_response_actions[player_offer_response] << 'PlayerTrade#create' if player_offer_response.affordable? && player_offer_response.agreeing?
                end
            end

            if any_incomplete_road_building_card_plays?
                game.borders.available_for_road.reachable_by(player).each do |border|
                    action_collection.border_actions[border] << 'RoadBuildingRoad#create'
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
        roll.blank? && all_robber_move_requirements_met?
    end

    def all_discard_requirements_met?
        discard_requirements.pending.empty?
    end

    def needs_robber_move?
        latest_robber_move_requirement&.needs_moved_to_territory?
    end
    alias can_move_robber? needs_robber_move?

    def needs_robbed_player?
        all_discard_requirements_met? && latest_robber_move_requirement&.needs_robbed_player?
    end

    def all_robber_move_requirements_met?
        !needs_robber_move? && !needs_robbed_player?
    end

    def can_take_action?
        roll.present? &&
            all_robber_move_requirements_met? &&
            all_discard_requirements_met? &&
            no_incomplete_road_building_card_plays? &&
            !ended?
    end
    alias can_end_turn? can_take_action?
    alias can_purchase? can_take_action?
    alias can_trade? can_take_action?
    alias can_play_development_cards? can_take_action?


    def can_purchase_settlement?
        can_purchase? &&
            player.brick_cards_count >= 1 &&
            player.grain_cards_count >= 1 &&
            player.lumber_cards_count >= 1 &&
            player.wool_cards_count >= 1 &&
            player.settlements.without_city_upgrade.size < 5
    end

    def can_purchase_road?
        can_purchase? &&
            player.brick_cards_count >= 1 &&
            player.lumber_cards_count >= 1
            player.roads.size < 15
    end

    def can_purchase_city_upgrade?
        can_purchase? &&
            player.grain_cards_count >= 2 &&
            player.ore_cards_count >= 3
            player.settlements.with_city_upgrade.size < 4
    end

    def can_purchase_development_card?
        can_purchase? &&
            player.grain_cards_count >= 1 &&
            player.ore_cards_count >= 1 &&
            player.wool_cards_count >= 1 &&
            game.development_cards.next_available.present?
    end

    def any_incomplete_road_building_card_plays?
        incomplete_road_building_card_plays.any?
    end

    def no_incomplete_road_building_card_plays?
        !any_incomplete_road_building_card_plays?
    end

    def ended?
        ended_at.present?
    end

    def build_next_turn
        RepeatingTurn.new(game: game, player: player.next_player)
    end
end
