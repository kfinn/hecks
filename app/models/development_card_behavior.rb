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

    def monopoly?
        self == MONOPOLY
    end

    def self.shuffled_deck
        for_deck = all.flat_map do |development_card_behavior|
            Array.new(development_card_behavior.count, development_card_behavior)
        end
        for_deck.shuffle
    end

    def can_play?(development_card, turn)
        return false unless monopoly?
        development_card.played_during_turn.blank? && turn != development_card.purchased_during_turn && turn.can_play_development_cards?
    end

    def development_card_actions(development_card, turn)
        return [] unless monopoly?
        if can_play?(development_card, turn)
            ['MonopolyCardPlay#create']
        else
            []
        end
    end
end
