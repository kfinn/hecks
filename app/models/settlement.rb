class Settlement < ApplicationRecord
    include GameChanging

    belongs_to :player
    belongs_to :corner
    has_one :game, through: :corner

    has_many :neighboring_corners, through: :corner
    has_many :borders, through: :corner

    has_one :harbor, through: :corner

    validates :corner, uniqueness: true
    validate :must_not_be_adjacent_to_another_settlement
    validate :game_must_be_started
    validate :player_must_not_have_too_many_settlements, if: :settlement?
    validate :player_must_not_have_too_many_cities, if: :city?

    delegate :color, to: :player

    scope :without_city_upgrade, -> { where(upgraded_to_city_at: nil) }
    scope :with_city_upgrade, -> { where.not(upgraded_to_city_at: nil) }

    after_create :recalculate_neighboring_opponents_longest_road_traversals!

    def must_not_be_adjacent_to_another_settlement
        other_neighboring_settlements = corner.neighboring_settlements - [self]
        if other_neighboring_settlements.any?
            errors[:corner] << 'must not be adjacent to an existing settlement'
        end
    end

    def game_must_be_started
        errors[:game] << 'must be started' unless game.started?
    end

    def player_must_not_have_too_many_settlements
        errors[:base] << 'no settlements left' if (player.settlements.without_city_upgrade - [self]).size >= 5
    end

    def player_must_not_have_too_many_cities
        errors[:base] << 'no cities left' if (player.settlements.with_city_upgrade - [self]).size >= 5
    end

    def settlement?
        upgraded_to_city_at.blank?
    end

    def city?
        upgraded_to_city_at.present?
    end

    def upgrade_to_city!
        self.update! upgraded_to_city_at: Time.zone.now
    end

    def resource_cards_per_production_roll
        city? ? 2 : 1
    end

    private

    def recalculate_neighboring_opponents_longest_road_traversals!
        neighboring_players = Player.where(id: Road.where(border: borders).select(:player_id))
        neighboring_opponents = neighboring_players - [player]
        neighboring_opponents.each(&:recalculate_longest_road_traversal!)
    end
end
