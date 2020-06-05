class HarborOffer < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :id

    self.data = [
        {
            id: 'generic_offer',
            exchange_rate: 3
        },
        {
            id: 'brick_offer',
            resource_to_give: Resource::BRICK,
        },
        {
            id: 'grain_offer',
            resource_to_give: Resource::GRAIN,
        },
        {
            id: 'lumber_offer',
            resource_to_give: Resource::LUMBER,
        },
        {
            id: 'ore_offer',
            resource_to_give: Resource::ORE,
        },
        {
            id: 'wool_offer',
            resource_to_give: Resource::WOOL,
        }
    ]

    field :exchange_rate, default: 2
end
