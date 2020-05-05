class Road < ApplicationRecord
    include GameChanging

    belongs_to :player
    belongs_to :border
    has_one :game, through: :border
    has_many :corners, through: :border
    has_many :settlements, through: :corners
    has_many :adjacent_borders, through: :corners, source: :borders
    has_many :adjacent_border_roads, -> { distinct }, through: :adjacent_borders, source: :road

    validates :border, uniqueness: true
    validate :must_connect_to_road_or_settlement
    validate :game_must_be_started

    def must_connect_to_road_or_settlement
        if settlements.where(player: player).any?
            return
        end
        if (adjacent_border_roads.where(player: player) - [self]).any?
            return
        end

        errors[:border] << 'must be connected to an existing settlement or road'
    end

    def game_must_be_started
        errors[:game] << 'must be started' unless game.started?
    end
end
