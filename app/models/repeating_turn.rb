class RepeatingTurn < Turn
    belongs_to :roll, optional: true

    validates :roll, presence: { if: :ended? }

    def actions
        return ActionCollection.none
    end

    def ended?
        ended_at.present?
    end

    def build_next_turn
        RepeatingTurn.new(game: game, player: player.next_player)
    end
end
