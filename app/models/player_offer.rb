class PlayerOffer < ApplicationRecord
    include GameChanging

    belongs_to :turn
    has_one :player, through: :turn
    has_one :game, through: :turn

    has_many :player_offer_responses

    validate :player_must_have_offered_resources
    validate :must_give_some_resources
    validate :must_receive_some_resources
    validates(
        :brick_cards_count_from_offering_player,
        :grain_cards_count_from_offering_player,
        :lumber_cards_count_from_offering_player,
        :ore_cards_count_from_offering_player,
        :wool_cards_count_from_offering_player,
        :brick_cards_count_from_agreeing_player,
        :grain_cards_count_from_agreeing_player,
        :lumber_cards_count_from_agreeing_player,
        :ore_cards_count_from_agreeing_player,
        :wool_cards_count_from_agreeing_player,
        presence: true,
        numericality: { greater_than_or_equal_to: 0 }
    )
    validate :must_not_offer_and_receive_same_resource

    delegate :name, to: :player, prefix: true

    def self.without_response_from_player(player)
        where.not(id: player.player_offer_responses.select(:player_offer_id))
    end

    def self.pending
        where.not(id: PlayerOfferResponse.completed.select(:player_offer_id))
    end

    def resource_count_from_offering_player(resource)
        send(attribute_name_for_resource_from_offering_player(resource))
    end

    def resource_count_from_agreeing_player(resource)
        send(attribute_name_for_resource_from_agreeing_player(resource))
    end

    def attribute_name_for_resource_from_agreeing_player(resource)
        "#{resource.attribute_name}_from_agreeing_player"
    end

    def offering_player_has_resources?
        Resource.all.all? do |resource|
            player.resource_cards_count(resource) >= resource_count_from_offering_player(resource)
        end
    end

    def affordable_for_agreeing_player?(agreeing_player)
        Resource.all.all? do |resource|
            agreeing_player.resource_cards_count(resource) >= resource_count_from_agreeing_player(resource)
        end
    end

    def offering_player_can_trade?
        turn.can_trade?
    end

    private

    def player_must_have_offered_resources
        Resource.all.each do |resource|
            attribute_name = attribute_name_for_resource_from_offering_player(resource)
            if player.resource_cards_count(resource) < send(attribute_name)
                errors[attribute_name] << 'not enough resources'
            end
        end
    end

    def must_give_some_resources
        errors[:base] << 'must offer to give some resources' unless total_resources_from_offering_player > 0
    end

    def total_resources_from_offering_player
        @total_resources_from_offering_player ||= Resource.all.map do |resource|
            resource_count_from_offering_player(resource)
        end.sum
    end

    def must_receive_some_resources
        errors[:base] << 'must offer to receive some resources' unless total_resources_from_agreeing_player > 0
    end

    def total_resources_from_agreeing_player
        @total_resources_from_agreeing_player ||= Resource.all.map do |resource|
            send(attribute_name_for_resource_from_agreeing_player(resource))
        end.sum
    end

    def must_not_offer_and_receive_same_resource
        any_resources_both_given_and_received = Resource.all.any? do |resource|
            resource_count_from_offering_player(resource) > 0 && resource_count_from_agreeing_player(resource) > 0
        end

        errors[:base] << 'cannot give and receive same resource' if any_resources_both_given_and_received
    end

    def attribute_name_for_resource_from_offering_player(resource)
        "#{resource.attribute_name}_from_offering_player"
    end
end
