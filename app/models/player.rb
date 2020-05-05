class Player < ApplicationRecord
    belongs_to :game
    belongs_to :user
    belongs_to :ordering_roll, class_name: 'Roll', optional: true
    belongs_to :initial_settlement, class_name: 'Settlement', optional: true
    belongs_to :initial_road, class_name: 'Road', optional: true

    delegate :name, to: :user
    delegate :value, to: :ordering_roll, prefix: true, allow_nil: true

    after_save :broadcast_to_game!
    after_destroy :broadcast_to_game!

    scope :ordered, -> { order(:ordering) }
    scope :without_initial_settlement, -> { where(initial_settlement: nil) }
    scope :without_initial_road, -> { where(initial_road: nil) }
    scope :without_initial_setup, -> { without_initial_settlement.or(without_initial_road) }

    def build_distinct_ordering_roll
        existing_ordering_roll_values = game.players.map(&:ordering_roll_value)
        build_ordering_roll
        while existing_ordering_roll_values.include? ordering_roll_value
            ordering_roll.roll!
        end
        ordering_roll
    end

    def broadcast_to_game!
        Rails.logger.info "broadcasting!"
        game.broadcast!
    end

    def earlier_players
        game.players.where('ordering < ?', ordering)
    end
end
