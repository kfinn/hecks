class DevelopmentCard < ApplicationRecord
    belongs_to_active_hash :development_card_behavior
    belongs_to :game
    belongs_to :player, optional: true
    belongs_to :purchased_during_turn, class_name: 'Turn', optional: true
    belongs_to :played_during_turn, class_name: 'Turn', optional: true

    scope :available_for_purchase, -> { where player: nil }
    scope :active, -> { where played_during_turn: nil }

    delegate :name, to: :development_card_behavior

    def self.next_available
        available_for_purchase.order(:ordering).first
    end
end
