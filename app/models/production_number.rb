class ProductionNumber < ActiveHash::Base
    self.data = [
        {
            id: 2,
            value: 2,
            frequency: 1,
            territories_count: 1
        },
        {
            id: 3,
            value: 3,
            frequency: 2,
            territories_count: 2
        },
        {
            id: 4,
            value: 4,
            frequency: 3,
            territories_count: 2
        },
        {
            id: 5,
            value: 5,
            frequency: 4,
            territories_count: 2
        },
        {
            id: 6,
            value: 6,
            frequency: 5,
            territories_count: 2
        },
        {
            id: 8,
            value: 8,
            frequency: 5,
            territories_count: 2
        },
        {
            id: 9,
            value: 9,
            frequency: 4,
            territories_count: 2
        },
        {
            id: 10,
            value: 10,
            frequency: 3,
            territories_count: 2
        },
        {
            id: 11,
            value: 11,
            frequency: 2,
            territories_count: 2
        },
        {
            id: 12,
            value: 12,
            frequency: 1,
            territories_count: 1
        }
    ]

    def self.shuffled
        for_territories = all.flat_map do |production_number|
            Array.new(production_number.territories_count, production_number)
        end
        for_territories.shuffle
    end
end
