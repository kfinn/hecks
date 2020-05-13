class Game < ApplicationRecord
    has_many :adjacencies

    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

    has_many :harbors, -> { distinct }, through: :corners

    has_many :settlements, -> { distinct }, through: :corners
    has_many :roads, -> { distinct }, through: :borders

    has_many :players
    has_many :users, through: :players

    has_many :development_cards

    has_many :turns
    belongs_to :current_turn, optional: true, class_name: 'Turn'
    has_one :current_player, through: :current_turn, source: :player

    has_many :repeating_turns
    has_many :rolls, through: :repeating_turns

    belongs_to :robber_territory, class_name: 'Territory'

    has_many :player_offers, -> { pending }, through: :current_turn
    has_many :player_offer_responses, through: :player_offers

    belongs_to :winner, optional: true, class_name: 'Player'

    before_validation :generate!, on: :create

    after_save :changed!

    def generate!
        self.key = 3.words.join('-')
        FourPlayerRandomizedBoard.new(game: self).generate!
        DevelopmentCardBehavior.shuffled_deck.each_with_index do |development_card_behavior, index|
            development_cards.build(development_card_behavior: development_card_behavior, ordering: index)
        end
    end

    def joinable?
        !started? && players.size < 4
    end

    def started?
        started_at.present?
    end

    def changed!
        broadcast!
    end

    def end_turn!
        if game_scoring.winner.present?
            update! winner: game_scoring.winner, current_turn: nil
        else
            update! current_turn: current_turn.build_next_turn
        end
    end

    def latest_roll
        unless instance_variable_defined?(:@latest_roll)
            @latest_roll = rolls.order(created_at: :desc).first
        end
        @latest_roll
    end

    def game_scoring
        @game_scoring ||= GameScoring.new(self)
    end

    private

    def broadcast!
        GamesChannel.broadcast_to(self, {})
    end
end
