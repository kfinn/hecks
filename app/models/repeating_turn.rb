class RepeatingTurn < Turn
    belongs_to :roll, optional: true

    validates :roll, presence: { if: :ended? }

    def actions
        ActionCollection.new.tap do |action_collection|
            if roll.blank?
                action_collection.dice_actions << 'ProductionRoll#create'
            end
        end
    end

    def can_create_production_roll?
        roll.nil? && current?
    end

    def ended?
        ended_at.present?
    end

    def build_next_turn
        RepeatingTurn.new(game: game, player: player.next_player)
    end
end
