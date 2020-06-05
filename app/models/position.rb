class Position
    attr_reader :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    PositionOffset = Struct.new(:x, :y)

    def +(other)
        Position.new(x + other.x, y + other.y)
    end

    TERRITORY_CORNER_OFFSETS = {
        north: PositionOffset.new(0, -3),
        northeast: PositionOffset.new(2, -1),
        southeast: PositionOffset.new(2, 1),
        south: PositionOffset.new(0, 3),
        southwest: PositionOffset.new(-2, 1),
        northwest: PositionOffset.new(-2, -1)
    }

    TERRITORY_BORDER_OFFSETS = {
        northwest: PositionOffset.new(-1, -2),
        northeast: PositionOffset.new(1, -2),
        east: PositionOffset.new(2, 0),
        southeast: PositionOffset.new(1, 2),
        southwest: PositionOffset.new(-1, 2),
        west: PositionOffset.new(-2, 0)
    }

    TERRITORY_NEIGHBOR_OFFSETS = {
        northwest: PositionOffset.new(-2, -4),
        northeast: PositionOffset.new(2, -4),
        east: PositionOffset.new(4, 0),
        southeast: PositionOffset.new(2, 4),
        southwest: PositionOffset.new(-2, 4),
        west: PositionOffset.new(-4, 0)
    }

    TERRITORY_CORNER_OFFSETS.each do |direction_name, offset|
        define_method "#{direction_name}_corner_position" do
            self + offset
        end
    end

    def corner_in_direction(direction)
        self + TERRITORY_CORNER_OFFSETS[direction]
    end

    TERRITORY_BORDER_OFFSETS.each do |direction_name, offset|
        define_method "#{direction_name}_border_position" do
            self + offset
        end
    end

    def neighboring_territory_positions
        TERRITORY_NEIGHBOR_OFFSETS.values.map do |offset|
            self + offset
        end
    end

    def ==(other)
        attributes == other.attributes
    end

    def eql?(other)
        attributes == other.attributes
    end

    delegate :hash, to: :attributes

    def attributes
        { x: x, y: y }
    end
end
