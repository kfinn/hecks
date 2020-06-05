class Terrain < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :name
    self.data = [
        {
            id: 'desert',
            name: 'Desert'
        },
        {
            id: 'fields',
            name: 'Fields',
            resource: Resource::GRAIN
        },
        {
            id: 'pasture',
            name: 'Pasture',
            resource: Resource::WOOL
        },
        {
            id: 'forest',
            name: 'Forest',
            resource: Resource::LUMBER
        },
        {
            id: 'mountains',
            name: 'Mountains',
            resource: Resource::ORE
        },
        {
            id: 'hills',
            name: 'Hills',
            resource: Resource::BRICK
        }
    ]

    def production?
        resource.present?
    end

    def desert?
        self == DESERT
    end
end
