class DevelopmentCard < ApplicationRecord
    include GameChanging
    belongs_to_active_hash :development_card_behavior
    belongs_to :game
    belongs_to :player, optional: true
    belongs_to :purchased_during_turn, class_name: 'Turn', optional: true
    belongs_to :played_during_turn, class_name: 'Turn', optional: true

    has_one :road_building_card_play

    scope :available_for_purchase, -> { where player: nil }
    scope :active, -> { where played_during_turn: nil }

    delegate(
        :name,
        :knight?,
        :monopoly?,
        :road_building?,
        :year_of_plenty?,
        to: :development_card_behavior
    )

    def self.next_available
        available_for_purchase.order(:ordering).first
    end

    def can_play?(turn)
        development_card_behavior.can_play?(self, turn)
    end

    def development_card_actions(turn)
        development_card_behavior.development_card_actions(self, turn)
    end

    def play!
        update! played_during_turn: player.current_turn
    end
end
