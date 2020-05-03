class Player < ApplicationRecord
    belongs_to :game
    belongs_to :user
    belongs_to :ordering_roll, class_name: 'Roll', optional: true

    delegate :name, to: :user
    delegate :value, to: :ordering_roll, prefix: true, allow_nil: true

    after_save :broadcast_to_game!

    def build_distinct_ordering_roll
        existing_ordering_roll_values = game.players.map(&:ordering_roll_value)
        build_ordering_roll
        while existing_ordering_roll_values.include? ordering_roll_value
            ordering_roll.roll!
        end
        ordering_roll
    end

    def broadcast_to_game!
        GamesChannel.broadcast_to(game, {})
    end
end
