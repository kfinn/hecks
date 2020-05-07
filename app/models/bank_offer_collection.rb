class BankOfferCollection
    include ActiveModel::Model
    include Enumerable
    attr_accessor :player

    delegate :each, to: :all

    def all
        eager!
        bank_offers_by_resource_to_give.values
    end

    def find(id)
        bank_offers_by_resource_to_give[id]
    end

    private

    def eager!
        Resource.all.map { |resource| bank_offers_by_resource_to_give[resource.id] }
    end

    def bank_offers_by_resource_to_give
        @bank_offers_by_resource_to_give ||= Hash.new do |hash, key|
            hash[key] = BankOffer.new(player: player, resource_to_give: Resource.find(key))
        end
    end
end
