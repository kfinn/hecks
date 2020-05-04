class Settlement < ApplicationRecord
    belongs_to :player
    belongs_to :corner
    has_one :game, through: :corner

    validate :must_not_be_adjacent_to_another_settlement

    after_save :broadcast_to_game!

    def must_not_be_adjacent_to_another_settlement
        other_neighboring_settlements = corner.neighboring_settlements - [self]
        if other_neighboring_settlements.any?
            errors[:corner] << 'must not be adjacent to an existing settlement'
        end
    end

    def broadcast_to_game!
        GamesChannel.broadcast_to(game, {})
    end
end
