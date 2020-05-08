class DiscardRequirement < ApplicationRecord
    belongs_to :player
    belongs_to :turn

    scope :pending, -> { where completed_at: nil }

    validates :resource_cards_count, presence: true

    before_validation :generate_resource_cards_count!, on: :create

    def generate_resource_cards_count!
        return if resource_cards_count.present?

        self.resource_cards_count = (player.total_resource_cards_count / 2).floor
    end

    def build_discard(params)
        Discard.new({ discard_requirement: self }.merge(params))
    end

    def pending?
        completed_at.blank?
    end

    def completed?
        completed_at.present?
    end

    def complete!
        update! completed_at: Time.zone.now
    end

    def actions
        if completed?
            ActionCollection.none
        else
            ActionCollection.new.tap do |action_collection|
                action_collection.pending_discard_requirement_actions << 'Discard#create'
            end
        end
    end
end
