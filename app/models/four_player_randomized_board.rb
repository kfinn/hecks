class FourPlayerRandomizedBoard
    include ActiveModel::Model

    attr_accessor :game

    delegate :adjacencies, to: :game

    Position = Struct.new(:x, :y)

    def generate!
        next_production_number_index = 0

        territories.each_with_index do |territory, index|
            territory.terrain = terrains[index]
            if territory.terrain != Terrain::DESERT
                territory.production_number = production_numbers[next_production_number_index]
                next_production_number_index += 1
            end

            x = territory.x
            y = territory.y

            northwest_border = borders_by_position[Position.new(2 * x, 2 * y)]
            north_corner = corners_by_position[Position.new(2 * x, 2 * y)]

            adjacencies.build(
                territory: territory,
                northwest_border: northwest_border,
                north_corner: north_corner
            )

            northeast_border = borders_by_position[Position.new(2 * x + 1, 2 * y)]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                north_corner: north_corner
            )

            northeast_corner = corners_by_position[Position.new(2 * x + 1, 2 * y)]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                northeast_corner: northeast_corner
            )

            east_border = borders_by_position[Position.new(2 * x + 2, 2 * y + 1)]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                northeast_corner: northeast_corner
            )

            southeast_corner = corners_by_position[Position.new(2 * x + 1, 2 * y + 1)]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                southeast_corner: southeast_corner
            )

            southeast_border = borders_by_position[Position.new(2 * x + 2, 2 * y + 2)]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                southeast_corner: southeast_corner
            )

            south_corner = corners_by_position[Position.new(2 * x + 1, 2 * y + 2)]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                south_corner: south_corner
            )

            southwest_border = borders_by_position[Position.new(2 * x + 1, 2 * y + 2)]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                south_corner: south_corner
            )

            southwest_corner = corners_by_position[Position.new(2 * x, 2 * y + 2)]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                southwest_corner: southwest_corner
            )

            west_border = borders_by_position[Position.new(2 * x, 2 * y + 1)]

            adjacencies.build(
                territory: territory,
                west_border: west_border,
                southwest_corner: southwest_corner
            )

            northwest_corner = corners_by_position[Position.new(2 * x, 2 * y + 1)]

            adjacencies.build(
                territory: territory,
                west_border: west_border,
                northwest_corner: northwest_corner
            )

            adjacencies.build(
                territory: territory,
                northwest_border: northwest_border,
                northwest_corner: northwest_corner
            )
        end
    end

    private

    BOARD_LAYOUT_ROWS = [
        { y: -2, x_range: -2..0 },
        { y: -1, x_range: -2..1 },
        { y: 0, x_range: -2..2 },
        { y: 1, x_range: -1..2 },
        { y: 2, x_range: 0..2 }
    ]


    def territories
        @territories ||= BOARD_LAYOUT_ROWS.each_with_object [] do |row, acc|
            y = row[:y]
            row[:x_range].each do |x|
                acc << Territory.new(x: x, y: y)
            end
        end
    end

    def terrains
        @terrains ||= Terrain.shuffled
    end

    def production_numbers
        @production_numbers ||= ProductionNumber.shuffled
    end

    def borders_by_position
        @borders_by_position ||= Hash.new do |hash, position|
            hash[position] = Border.new(x: position.x, y: position.y)
        end
    end

    def corners_by_position
        @corners_by_position ||= Hash.new do |hash, position|
            hash[position] = Corner.new(x: position.x, y: position.y)
        end
    end
end
