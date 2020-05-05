class Turn < ApplicationRecord
    belongs_to :player
    belongs_to :game

    scope :current, -> { where(id: Game.all.select(:current_turn_id)) }

    def current?
        game.current_turn == self
    end
end
