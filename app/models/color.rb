class Color < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :name
    self.data = [
        { id: 'blue' },
        { id: 'white' },
        { id: 'red' },
        { id: 'orange' },
        { id: 'teal' },
        { id: 'brown' },
        { id: 'pink' }
    ]
end
