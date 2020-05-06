class Player < ApplicationRecord
    include GameChanging

    belongs_to :game
    belongs_to :user
    belongs_to :ordering_roll, class_name: 'Roll', optional: true

    has_one :current_turn, -> { current }, class_name: 'Turn'

    has_one :initial_setup_turn
    has_one :initial_settlement, through: :initial_setup_turn, source: :settlement
    has_one :initial_road, through: :initial_setup_turn, source: :road

    has_one :initial_second_setup_turn
    has_one :initial_second_settlement, through: :initial_second_setup_turn, source: :settlement
    has_one :initial_second_road, through: :initial_second_setup_turn, source: :road

    has_many :settlements
    has_many :roads

    has_one :current_repeating_turn, -> { current }, class_name: 'RepeatingTurn'

    belongs_to_active_hash :color

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
    delegate :can_create_production_roll?, :can_end_turn?, :can_purchase_settlement?, :can_purchase_road?, to: :current_repeating_turn, allow_nil: true

    delegate :corner_actions, :border_actions, :dice_actions, to: :actions

    validates :brick_cards_count, :grain_cards_count, :lumber_cards_count, :ore_cards_count, :wool_cards_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :color, presence: true, uniqueness: { scope: :game }, inclusion: { in: Color.all }

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
        @actions = current_turn&.actions || ActionCollection.none
    end

    def collect_resource(resource, amount=1)
        attribute_name = "#{resource.name}_cards_count"
        current_resource_cards_count = send(attribute_name)
        send("#{attribute_name}=", current_resource_cards_count + amount)
    end
end
