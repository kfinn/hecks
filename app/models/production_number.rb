class ProductionNumber < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :name

    self.data = [
        {
            id: 2,
            value: 2,
            name: 'two',
            frequency: 1
        },
        {
            id: 3,
            value: 3,
            name: 'three',
            frequency: 2
        },
        {
            id: 4,
            value: 4,
            name: 'four',
            frequency: 3
        },
        {
            id: 5,
            value: 5,
            name: 'five',
            frequency: 4
        },
        {
            id: 6,
            value: 6,
            name: 'six',
            frequency: 5
        },
        {
            id: 8,
            value: 8,
            name: 'eight',
            frequency: 5
        },
        {
            id: 9,
            value: 9,
            name: 'nine',
            frequency: 4
        },
        {
            id: 10,
            value: 10,
            name: 'ten',
            frequency: 3
        },
        {
            id: 11,
            value: 11,
            name: 'eleven',
            frequency: 2
        },
        {
            id: 12,
            value: 12,
            name: 'twelve',
            frequency: 1
        }
    ]

    def high_frequency?
        frequency == 5
    end

    def low_frequency?
        frequency == 1
    end
end
