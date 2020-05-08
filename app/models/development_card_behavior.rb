class DevelopmentCardBehavior < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :name
    self.data = [
        {
            id: 'knight',
            name: 'Knight',
            count: 14
        },
        {
            id: 'victory_point',
            name: 'Victory Point',
            count: 5
        },
        {
            id: 'monopoly',
            name: 'Monopoly',
            count: 2
        },
        {
            id: 'road_building',
            name: 'Road Building',
            count: 2
        },
        {
            id: 'year_of_plenty',
            name: 'Year of Plenty',
            count: 2
        }
    ]

    def self.shuffled_deck
        for_deck = all.flat_map do |development_card_behavior|
            Array.new(development_card_behavior.count, development_card_behavior)
        end
        for_deck.shuffle
    end
end
