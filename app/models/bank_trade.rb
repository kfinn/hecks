class BankTrade
    include ActiveModel::Model
    attr_accessor :bank_offer, :resource_to_receive

    delegate :player, :resource_to_give, :resource_to_give_count_required, :affordable?, to: :bank_offer

    validate :player_must_be_able_to_trade
    validate :must_be_affordable

    def save!
        raise ActiveRecord::RecordInvalid(self) unless valid?
        update_player!
    end

    def resource_to_receive_id=(resource_to_receive_id)
        self.resource_to_receive = Resource.find(resource_to_receive_id)
    end

    private

    def player_must_be_able_to_trade
        errors[:player] << 'cannot trade' unless player.can_trade?
    end

    def must_be_affordable
        errors[:player] << "must have #{resource_to_give_count_required} of the giving resource" unless affordable?
    end

    def update_player!
        player.discard_resource(resource_to_give, resource_to_give_count_required)
        player.collect_resource(resource_to_receive)
        player.save!
    end
end
