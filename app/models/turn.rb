class Turn < ApplicationRecord
    include GameChanging

    belongs_to :player
    belongs_to :game
    has_many :player_offers

    scope :current, -> { where(id: Game.all.select(:current_turn_id)) }

    def current?
        game.current_turn == self
    end
end
