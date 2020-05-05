class Player < ApplicationRecord
    include GameChanging

    belongs_to :game
    belongs_to :user
    belongs_to :ordering_roll, class_name: 'Roll', optional: true

    has_one :initial_setup_turn
    has_one :initial_settlement, through: :initial_setup_turn, source: :settlement
    has_one :initial_road, through: :initial_setup_turn, source: :road

    has_one :initial_second_setup_turn
    has_one :initial_second_settlement, through: :initial_second_setup_turn, source: :settlement
    has_one :initial_second_road, through: :initial_second_setup_turn, source: :road

    delegate :name, to: :user
    delegate :value, to: :ordering_roll, prefix: true, allow_nil: true

    scope :ordered, -> { order(:ordering) }

    scope :without_initial_settlement, -> { where(initial_settlement: nil) }
    scope :without_initial_road, -> { where(initial_road: nil) }
    scope :without_initial_setup, -> { without_initial_settlement.or(without_initial_road) }

    scope :without_initial_second_settlement, -> { where(initial_second_settlement: nil) }
    scope :without_initial_second_road, -> { where(initial_second_road: nil) }
    scope :without_initial_second_setup, -> { without_initial_second_settlement.or(without_initial_second_road) }

    delegate :can_create_initial_settlement?, :can_create_initial_road?, to: :initial_setup_turn, allow_nil: true
    delegate :can_create_initial_second_settlement?, :can_create_initial_second_road?, to: :initial_second_setup_turn, allow_nil: true

    def build_distinct_ordering_roll
        existing_ordering_roll_values = game.players.map(&:ordering_roll_value)
        build_ordering_roll
        while existing_ordering_roll_values.include? ordering_roll_value
            ordering_roll.roll!
        end
        ordering_roll
    end

    def next_player
        @next_player ||= later_players.ordered.first || game.players.ordered.first
    end

    def previous_player
        @previous_player ||= earlier_players.ordered.last || game.players.ordered.last
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
            if game.current_player == self

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

    def collect_resource(resource, amount=1)
        attribute_name = "#{resource.name}_cards_count"
        current_resource_cards_count = send(attribute_name)
        send("#{attribute_name}=", current_resource_cards_count + amount)
    end
end
