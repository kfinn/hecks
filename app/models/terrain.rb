class Terrain < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :name
    self.data = [
        {
            id: 'desert',
            name: 'Desert',
            territories_count: 1
        },
        {
            id: 'fields',
            name: 'Fields',
            territories_count: 4,
            resource: Resource::GRAIN
        },
        {
            id: 'pasture',
            name: 'Pasture',
            territories_count: 4,
            resource: Resource::WOOL
        },
        {
            id: 'forest',
            name: 'Forest',
            territories_count: 4,
            resource: Resource::LUMBER
        },
        {
            id: 'mountains',
            name: 'Mountains',
            territories_count: 3,
            resource: Resource::ORE
        },
        {
            id: 'hills',
            name: 'Hills',
            territories_count: 3,
            resource: Resource::BRICK
        }
    ]

    def self.shuffled
        for_territories = all.flat_map do |terrain|
            Array.new(terrain.territories_count, terrain)
        end
        for_territories.shuffle
    end

    def production?
        resource.present?
    end

    def desert?
        self == DESERT
    end
end
