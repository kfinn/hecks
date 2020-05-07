class Resource < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :name
    self.data = [
        {
            id: 'brick',
            name: 'brick'
        },
        {
            id: 'grain',
            name: 'grain'
        },
        {
            id: 'lumber',
            name: 'lumber'
        },
        {
            id: 'ore',
            name: 'ore'
        },
        {
            id: 'wool',
            name: 'wool'
        }
    ]

    def owned_by_player(player)
        player.send(player_attribute_name)
    end

    def exchange_rate_for_player(player)
        return 4
    end

    def player_attribute_name
        "#{name}_cards_count"
    end

    def player_attribute_setter_name
        "#{player_attribute_name}="
    end
end
