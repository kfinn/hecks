class PlayerOfferAgreement < ApplicationRecord
    include GameChanging

    belongs_to :player_offer
    belongs_to :player
    has_one :game, through: :player_offer

    validate :player_must_have_offered_resources, on: :create

    delegate(
        :resource_count_from_offering_player,
        :resource_count_from_agreeing_player,
        :attribute_name_for_resource_from_agreeing_player,
        :offering_player_has_resources?,
        :offering_player_can_trade?,
        to: :player_offer
    )
    delegate :name, to: :player, prefix: true

    scope :completed, -> { where.not(completed_at: nil) }

    def agreeing_player_has_resources?
        Resource.all.all? do |resource|
            player.resource_cards_count(resource) >= resource_count_from_agreeing_player(resource)
        end
    end

    def offering_player
        player_offer.player
    end

    def affordable?
        offering_player_has_resources? && agreeing_player_has_resources?
    end

    def complete!
        update! completed_at: Time.zone.now
    end

    private

    def player_must_have_offered_resources
        Resource.all.each do |resource|
            attribute_name = attribute_name_for_resource_from_agreeing_player(resource)
            if player.resource_cards_count(resource) < resource_count_from_agreeing_player(resource)
                errors[attribute_name] << 'not enough resources'
            end
        end
    end
end
