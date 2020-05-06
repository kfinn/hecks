class RepeatingTurn < Turn
    belongs_to :roll, optional: true

    validates :roll, presence: { if: :ended? }

    def actions
        ActionCollection.new.tap do |action_collection|
            if can_create_production_roll?
                action_collection.dice_actions << 'ProductionRoll#create'
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
        end
    end

    def can_create_production_roll?
        roll.nil? && current?
    end

    def can_end_turn?
        roll.present? && current?
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

    def ended?
        ended_at.present?
    end

    def active?
        !ended?
    end

    def can_purchase?
        current? && active? && roll.present?
    end

    def build_next_turn
        RepeatingTurn.new(game: game, player: player.next_player)
    end
end
