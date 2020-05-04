class Game < ApplicationRecord
    has_many :adjacencies

    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

    has_many :settlements, -> { distinct }, through: :corners

    has_many :players
    has_many :users, through: :players

    before_create :generate!

    after_save :broadcast!

    def generate!
        self.key = 3.words.join('-')
        FourPlayerRandomizedBoard.new(game: self).generate!
    end

    def start!
        transaction do
            players.each(&:build_distinct_ordering_roll)
            sorted_players = players.sort_by { |player| -player.ordering_roll_value }
            sorted_players.each_with_index do |player, index|
                player.ordering = index
                player.save!
            end
            update! started_at: Time.zone.now
        end
    end

    def joinable?
        !started?
    end

    def started?
        started_at.present?
    end

    def broadcast!
        GamesChannel.broadcast_to(self, {})
    end

    def current_player
        players.without_initial_settlement.ordered.first
    end
end
