class Turn < ApplicationRecord
    include GameChanging

    belongs_to :player
    belongs_to :game
    has_many :player_offers
    has_many :special_build_phases
    has_many :special_build_phase_players, through: :special_build_phases, source: :player

    scope :current, -> { where(id: Game.all.select(:current_turn_id)) }

    def current?
        game.current_turn == self
    end
end
