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

    has_many :harbors, through: :settlements

    has_one :current_repeating_turn, -> { current }, class_name: 'RepeatingTurn'
    has_many :incomplete_road_building_card_plays, through: :current_repeating_turn

    has_many :discard_requirements
    has_one :pending_discard_requirement, -> { pending }, class_name: 'DiscardRequirement'

    has_many :player_offer_responses

    belongs_to_active_hash :color

    has_many :development_cards
    has_many :active_development_cards, -> { active }, class_name: 'DevelopmentCard'
    has_many :played_knight_cards, -> { played.knight }, class_name: 'DevelopmentCard'

    delegate :value, to: :ordering_roll, prefix: true, allow_nil: true

    scope :ordered, -> { order(:ordering) }

    scope :without_initial_settlement, -> { where(initial_settlement: nil) }
    scope :without_initial_road, -> { where(initial_road: nil) }
    scope :without_initial_setup, -> { without_initial_settlement.or(without_initial_road) }

    scope :without_initial_second_settlement, -> { where(initial_second_settlement: nil) }
    scope :without_initial_second_road, -> { where(initial_second_road: nil) }
    scope :without_initial_second_setup, -> { without_initial_second_settlement.or(without_initial_second_road) }

    def self.with_resource_cards
        where("#{Resource.all.map(&:attribute_name).join(' + ')} > ?", 0)
    end

    def self.with_more_than_seven_resource_cards
        where("#{Resource.all.map(&:attribute_name).join(' + ')} > ?", 7)
    end

    delegate :can_create_initial_settlement?, :can_create_initial_road?, to: :initial_setup_turn, allow_nil: true
    delegate(
        :can_create_initial_second_road?,
        :can_create_initial_second_settlement?,
        to: :initial_second_setup_turn,
        allow_nil: true
    )
    delegate(
        :can_create_production_roll?,
        :can_end_turn?,
        :can_move_robber?,
        :can_purchase_city_upgrade?,
        :can_purchase_development_card?,
        :can_purchase_road?,
        :can_purchase_settlement?,
        :can_rob_player?,
        :can_trade?,
        :any_incomplete_road_building_card_plays?,
        to: :current_repeating_turn,
        allow_nil: true
    )

    delegate(
        *[*ActionCollection::SUBCOLLECTIONS, *ActionCollection::SINGULAR_SUBCOLLECTIONS],
        to: :actions
    )

    validates(
        :brick_cards_count,
        :grain_cards_count,
        :lumber_cards_count,
        :ore_cards_count,
        :wool_cards_count,
        presence: true,
        numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    )
    validates :color, presence: true, uniqueness: { scope: :game }, inclusion: { in: Color.all }
    validate :game_must_be_joinable, on: :create

    before_validation :assign_color, on: :create

    def build_distinct_ordering_roll
        existing_ordering_roll_values = game.players.map(&:ordering_roll_value)
        build_ordering_roll
        while existing_ordering_roll_values.include? ordering_roll_value
            ordering_roll.roll!
        end
        ordering_roll
    end

    def name
        super || "Player #{id}"
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
        @actions ||= [
            current_turn&.actions, pending_discard_requirement&.actions, receiving_player_offer_actions
        ].compact.reduce(ActionCollection.none) do |actions, acc|
            acc.merge(actions)
        end
    end

    def receiving_player_offer_actions
        unless instance_variable_defined?(:@receiving_player_offer_actions)
            if current_turn.present?
                @receiving_player_offer_actions = ActionCollection.none
            else
                @receiving_player_offer_actions = ActionCollection.new
                game
                    .player_offers
                    .without_response_from_player(self)
                    .each do |respondable_player_offer|
                        if respondable_player_offer.affordable_for_agreeing_player?(self)
                            @receiving_player_offer_actions.player_offer_actions[respondable_player_offer] << 'PlayerOfferAgreement#create'
                        end
                        @receiving_player_offer_actions.player_offer_actions[respondable_player_offer] << 'PlayerOfferRejection#create'
                    end
            end
        end
        @receiving_player_offer_actions
    end

    def bank_offers
        @bank_offers ||= BankOfferCollection.new(player: self)
    end

    def resource_cards_count(resource)
        send(resource.attribute_name)
    end

    def total_resource_cards_count
        Resource.all.map { |resource| resource_cards_count(resource) }.sum
    end

    def active_development_cards_count
        active_development_cards.size
    end

    def played_knight_cards_count
        played_knight_cards.size
    end

    def collect_resource(resource, amount=1)
        raise 'can only collect a positive number of resource cards' if amount < 1
        current_resource_cards_count = send(resource.attribute_name)
        send(resource.attribute_setter_name, current_resource_cards_count + amount)
    end

    def discard_resource(resource, amount=1)
        raise 'can only remove a positive number of resource cards' if amount < 1
        current_resource_cards_count = send(resource.attribute_name)
        send(resource.attribute_setter_name, current_resource_cards_count - amount)
    end

    private

    def game_must_be_joinable
        errors[:game] << 'must be joinable' unless game.joinable?
    end

    def assign_color
        used_colors = game.players.map(&:color)
        self.color = (Color.all.to_a - used_colors).first
    end
end
