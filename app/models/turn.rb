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

    def allows_special_build_phase?
        false
    end

    def can_create_production_roll?
        false
    end

    def can_end_turn?
        false
    end

    def can_move_robber?
        false
    end

    def can_purchase_city_upgrade?
        false
    end

    def can_purchase_development_card?
        false
    end

    def can_purchase_road?
        false
    end

    def can_purchase_settlement?
        false
    end

    def can_rob_player?
        false
    end

    def can_trade?
        false
    end

    def any_incomplete_road_building_card_plays?
        false
    end
end
