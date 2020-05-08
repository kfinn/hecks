class Game < ApplicationRecord
    has_many :adjacencies

    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

    has_many :settlements, -> { distinct }, through: :corners
    has_many :roads, -> { distinct }, through: :borders

    has_many :players
    has_many :users, through: :players

    has_many :turns
    belongs_to :current_turn, optional: true, class_name: 'Turn'
    has_one :current_player, through: :current_turn, source: :player

    has_many :repeating_turns
    has_many :rolls, through: :repeating_turns

    belongs_to :robber_territory, class_name: 'Territory'

    has_many :player_offers, through: :current_turn

    before_validation :generate!, on: :create

    after_save :changed!

    def generate!
        self.key = 3.words.join('-')
        FourPlayerRandomizedBoard.new(game: self).generate!
    end

    def joinable?
        !started?
    end

    def started?
        started_at.present?
    end

    def changed!
        broadcast!
    end

    def end_turn!
        update! current_turn: current_turn.build_next_turn
    end

    def latest_roll
        unless instance_variable_defined?(:@latest_roll)
            @latest_roll = rolls.order(created_at: :desc).first
        end
        @latest_roll
    end

    private

    def broadcast!
        GamesChannel.broadcast_to(self, {})
    end
end
