class HarborOrientation
    attr_reader :position, :corner_directions

    def initialize(position, corner_directions)
        @position = position
        @corner_directions = corner_directions
    end

    def corner_positions
        corner_directions.map do |corner_direction|
            position.corner_in_direction(corner_direction)
        end
    end
end
