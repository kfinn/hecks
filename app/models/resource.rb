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
end
