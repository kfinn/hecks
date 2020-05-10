class BankOffer
    include ActiveModel::Model

    attr_accessor :player, :resource_to_give

    delegate :hash, to: :attributes

    def affordable?
        player.resource_cards_count(resource_to_give) >= resource_to_give_count_required
    end

    def resource_to_give_count_required
        unless instance_variable_defined?(:@resource_to_give_count_required)
            if player.harbors.where(harbor_offer_id: specific_harbor_offer.id).any?
                @resource_to_give_count_required = specific_harbor_offer.exchange_rate
            elsif player.harbors.where(harbor_offer_id: HarborOffer::GENERIC_OFFER.id).any?
                @resource_to_give_count_required = HarborOffer::GENERIC_OFFER.exchange_rate
            else
                @resource_to_give_count_required = 4
            end
        end
        @resource_to_give_count_required
    end

    def build_bank_trade(params)
        BankTrade.new(**({ bank_offer: self }.merge(params)))
    end

    def ==(other)
        attributes == other.attributes
    end

    def eql?(other)
        attributes.eql? other.attributes
    end

    def attributes
        { player: player, resource_to_give: resource_to_give }
    end

    def specific_harbor_offer
        @specific_harbor_offer ||= HarborOffer.find_by(resource_to_give: resource_to_give)
    end
end
