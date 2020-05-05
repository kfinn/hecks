class Player < ApplicationRecord
    belongs_to :game
    belongs_to :user
    belongs_to :ordering_roll, class_name: 'Roll', optional: true
    belongs_to :initial_settlement, class_name: 'Settlement', optional: true
    belongs_to :initial_road, class_name: 'Road', optional: true
    belongs_to :initial_second_settlement, class_name: 'Settlement', optional: true
    belongs_to :initial_second_road, class_name: 'Road', optional: true

    delegate :name, to: :user
    delegate :value, to: :ordering_roll, prefix: true, allow_nil: true

    after_save :broadcast_to_game!
    after_destroy :broadcast_to_game!

    scope :ordered, -> { order(:ordering) }

    scope :without_initial_settlement, -> { where(initial_settlement: nil) }
    scope :without_initial_road, -> { where(initial_road: nil) }
    scope :without_initial_setup, -> { without_initial_settlement.or(without_initial_road) }

    scope :without_initial_second_settlement, -> { where(initial_second_settlement: nil) }
    scope :without_initial_second_road, -> { where(initial_second_road: nil) }
    scope :without_initial_second_setup, -> { without_initial_second_settlement.or(without_initial_second_road) }

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

    def later_players
        game.players.where('ordering > ?', ordering)
    end

    def actions
        unless instance_variable_defined?(:@actions)
            @actions = Hash.new { |hash, key| hash[key] = [] }
            if game.started?

                if can_create_initial_settlement?
                    game.corners.available_for_settlement.each do |corner|
                        @actions[corner] << 'InitialSettlement#create'
                    end
                elsif can_create_initial_second_settlement?
                    game.corners.available_for_settlement.each do |corner|
                        @actions[corner] << 'InitialSecondSettlement#create'
                    end
                end

                if can_create_initial_road?
                    initial_settlement.borders.each do |border|
                        @actions[border] << 'InitialRoad#create'
                    end
                elsif can_create_initial_second_road?
                    initial_second_settlement.borders.each do |border|
                        @actions[border] << 'InitialSecondRoad#create'
                    end
                end
            end
        end
        @actions
    end

    def can_create_initial_settlement?
        initial_settlement.blank? && earlier_players.without_initial_setup.none?
    end

    def can_create_initial_road?
        initial_settlement.present? && initial_road.blank? && earlier_players.without_initial_setup.none?
    end

    def can_create_initial_second_settlement?
        initial_second_settlement.blank? &&
            game.players.without_initial_setup.empty? &&
            later_players.without_initial_second_setup.empty?
    end

    def can_create_initial_second_road?
        initial_second_settlement.present? &&
            initial_second_road.blank? &&
            game.players.without_initial_setup.empty? &&
            later_players.without_initial_second_setup.empty?
    end

    def collect_resource(resource, amount=1)
        attribute_name = "#{resource.name}_cards_count"
        current_resource_cards_count = send(attribute_name)
        send("#{attribute_name}=", current_resource_cards_count + amount)
    end
end
