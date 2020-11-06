class SpecialBuildPhaseTurn < Turn
    belongs_to :special_build_phase

    before_validation :initialize_player, on: :create
    validate :player_must_match_special_build_phase_player

    has_one :turn, through: :special_build_phase

    delegate :build_next_turn, :build_special_build_phase, to: :turn

    def allows_special_build_phase?
        true
    end

    def description
        'build something or end the turn'
    end

    def actions
        return ActionCollection.none unless current?

        ActionCollection.new.tap do |action_collection|
            action_collection.turn_actions << 'SpecialBuildPhaseTurnEnds#create'

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
        end
    end

    def can_purchase?
        current? && !ended?
    end

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
            player.lumber_cards_count >= 1 &&
            player.roads.size < 15
    end

    def can_purchase_city_upgrade?
        can_purchase? &&
            player.grain_cards_count >= 2 &&
            player.ore_cards_count >= 3 &&
            player.settlements.with_city_upgrade.size < 4
    end

    def can_purchase_development_card?
        can_purchase? &&
            player.grain_cards_count >= 1 &&
            player.ore_cards_count >= 1 &&
            player.wool_cards_count >= 1 &&
            game.development_cards.next_available.present?
    end

    def ended?
        ended_at.present?
    end

    def can_player_create_special_build_phase?(player)
        (
            self.player.ordering < player.ordering ||
            player.ordering < turn.player.ordering
        ) && turn.special_build_phase_players.exclude?(player)
    end

    private

    def initialize_player
        self.player ||= special_build_phase.player
    end

    def player_must_match_special_build_phase_player
        errors[:player] << 'must match special build phase player' unless player == special_build_phase.player
    end
end
