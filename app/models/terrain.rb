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
            territories_count: 4
        },
        {
            id: 'pasture',
            name: 'Pasture',
            territories_count: 4
        },
        {
            id: 'forest',
            name: 'Forest',
            territories_count: 4
        },
        {
            id: 'mountains',
            name: 'Mountains',
            territories_count: 3
        },
        {
            id: 'hills',
            name: 'Hills',
            territories_count: 3
        }
    ]

    def self.shuffled
        for_territories = all.flat_map do |terrain|
            Array.new(terrain.territories_count) { terrain }
        end
        for_territories.sample(for_territories.size)
    end
end
