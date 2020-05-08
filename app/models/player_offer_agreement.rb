class PlayerOfferAgreement < ApplicationRecord
    include GameChanging

    belongs_to :player_offer
    belongs_to :player
    has_one :game, through: :player_offer

    validate :player_must_have_offered_resources, on: :create

    delegate :resource_count_from_offering_player, :resource_count_from_agreeing_player, :attribute_name_for_resource_from_agreeing_player, to: :player_offer
    delegate :name, to: :player, prefix: true

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
