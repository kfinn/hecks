class PlayerTrade
    include ActiveModel::Model
    attr_accessor :player_offer_response

    delegate(
        :agreeing_player_has_resources?,
        :resource_count_from_offering_player,
        :resource_count_from_agreeing_player,
        :offering_player_has_resources?,
        :offering_player_can_trade?,
        :offering_player,
        to: :player_offer_response
    )

    validates :player_offer_response, presence: true
    validate :player_offer_response_must_be_agreeing
    validate :offering_player_must_have_resources
    validate :agreeing_player_must_have_resources
    validate :offering_player_must_be_able_to_trade

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            update_players!
            player_offer_response.complete!
        end
    end

    private

    def offering_player_must_have_resources
        errors[:base] << 'not enough resources from offering player' unless offering_player_has_resources?
    end

    def agreeing_player_must_have_resources
        errors[:base] << 'not enough resources from agreeing player' unless agreeing_player_has_resources?
    end

    def offering_player_must_be_able_to_trade
        errors[:base] << 'cannot trade' unless offering_player_can_trade?
    end

    def player_offer_response_must_be_agreeing
        errors[:player_offer_response] << 'did not agree' unless player_offer_response.agreeing?
    end

    def update_players!
        Resource.all.each do |resource|
            from_offering_player_to_agreeing_player = resource_count_from_offering_player(resource)
            if from_offering_player_to_agreeing_player > 0
                offering_player.discard_resource(resource, from_offering_player_to_agreeing_player)
                agreeing_player.collect_resource(resource, from_offering_player_to_agreeing_player)
            end

            from_agreeing_player_to_offering_player = resource_count_from_agreeing_player(resource)
            if from_agreeing_player_to_offering_player > 0
                agreeing_player.discard_resource(resource, from_agreeing_player_to_offering_player)
                offering_player.collect_resource(resource, from_agreeing_player_to_offering_player)
            end
        end
        agreeing_player.save!
        offering_player.save!
    end

    def agreeing_player
        player_offer_response.player
    end
end
