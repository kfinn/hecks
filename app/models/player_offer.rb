class PlayerOffer < ApplicationRecord
    include GameChanging

    belongs_to :turn
    has_one :player, through: :turn
    has_one :game, through: :turn

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

    delegate :name, to: :player, prefix: true

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
            send(attribute_name_for_resource_from_offering_player(resource))
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

    def attribute_name_for_resource_from_offering_player(resource)
        "#{resource.attribute_name}_from_offering_player"
    end

    def attribute_name_for_resource_from_agreeing_player(resource)
        "#{resource.attribute_name}_from_agreeing_player"
    end
end
