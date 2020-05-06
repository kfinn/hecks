class Settlement < ApplicationRecord
    include GameChanging

    belongs_to :player
    belongs_to :corner
    has_one :game, through: :corner

    has_many :neighboring_corners, through: :corner
    has_many :borders, through: :corner

    validates :corner, uniqueness: true
    validate :must_not_be_adjacent_to_another_settlement
    validate :game_must_be_started

    delegate :color, to: :player

    def must_not_be_adjacent_to_another_settlement
        other_neighboring_settlements = corner.neighboring_settlements - [self]
        if other_neighboring_settlements.any?
            errors[:corner] << 'must not be adjacent to an existing settlement'
        end
    end

    def game_must_be_started
        errors[:game] << 'must be started' unless game.started?
    end
end