class BankOffer
    include ActiveModel::Model

    attr_accessor :player, :resource_to_give

    delegate :hash, to: :attributes

    def affordable?
        player.resource_cards_count(resource_to_give) >= resource_to_give_count_required
    end

    def resource_to_give_count_required
        4
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
end
