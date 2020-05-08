class Resource < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :name
    self.data = [
        'brick',
        'grain',
        'lumber',
        'ore',
        'wool'
    ].map do |resource_name|
        {
            id: resource_name,
            name: resource_name
        }
    end

    def exchange_rate_for_player(player)
        return 4
    end

    def attribute_name
        "#{name}_cards_count"
    end

    def attribute_setter_name
        "#{attribute_name}="
    end
end
