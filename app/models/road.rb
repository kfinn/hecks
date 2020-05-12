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
    validate :player_must_not_have_too_many_roads

    delegate :color, to: :player

    after_create :recalculate_player_longest_road_traversal!

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

    def player_must_not_have_too_many_roads
        errors[:base] << 'no roads left' if (player.roads - [self]).size >= 15
    end

    def recalculate_player_longest_road_traversal!
        player.recalculate_longest_road_traversal!
    end
end
