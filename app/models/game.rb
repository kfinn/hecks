class Game < ApplicationRecord
    has_many :adjacencies

    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

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
