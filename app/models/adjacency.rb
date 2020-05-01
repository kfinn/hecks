class Adjacency < ApplicationRecord
    belongs_to :game
    belongs_to :corner
    belongs_to :border
    belongs_to :territory

    validates :border_territory_relationship, :corner_territory_relationship, presence: true

    enum border_territory_relationship: {
        northeast_border: 'northeast',
        east_border: 'east',
        southeast_border: 'southeast',
        southwest_border: 'southwest',
        west_border: 'west',
        northwest_border: 'northwest'
    }

    enum corner_territory_relationship: {
        north_corner: 'north',
        northeast_corner: 'northeast',
        southeast_corner: 'southeast',
        south_corner: 'south',
        southwest_corner: 'southwest',
        northwest_corner: 'northwest'
    }

    border_territory_relationships.keys.each do |border_territory_relationship|
        define_method("#{border_territory_relationship}=") do |border|
            self.border = border
            self.border_territory_relationship = border_territory_relationship
        end

        define_method(border_territory_relationship) do
            raise if self.border_territory_relationship != border_territory_relationship
            self.border
        end
    end

    corner_territory_relationships.keys.each do |corner_territory_relationship|
        define_method("#{corner_territory_relationship}=") do |corner|
            self.corner = corner
            self.corner_territory_relationship = corner_territory_relationship
        end

        define_method(corner_territory_relationship) do
            raise if self.corner_territory_relationship != corner_territory_relationship
            self.corner
        end
    end
end
