class Color < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :name
    self.data = [
        {
            id: 'blue',
            name: 'blue'
        },
        {
            id: 'white',
            name: 'white'
        },
        {
            id: 'red',
            name: 'red'
        },
        {
            id: 'orange',
            name: 'orange'
        }
    ]
end
