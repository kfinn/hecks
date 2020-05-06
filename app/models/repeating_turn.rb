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
        end
    end

    def can_create_production_roll?
        roll.nil? && current?
    end

    def can_end_turn?
        roll.present? && current?
    end

    def ended?
        ended_at.present?
    end

    def build_next_turn
        RepeatingTurn.new(game: game, player: player.next_player)
    end
end
