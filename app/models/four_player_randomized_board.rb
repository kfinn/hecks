class FourPlayerRandomizedBoard
    include ActiveModel::Model

    attr_accessor :game

    delegate :adjacencies, to: :game

    Position = Struct.new(:x, :y) do
        def +(other)
            Position.new(x + other.x, y + other.y)
        end
    end

    CORNER_OFFSETS = {
        north: Position.new(0, -3),
        northeast: Position.new(2, -1),
        southeast: Position.new(2, 1),
        south: Position.new(0, 3),
        southwest: Position.new(-2, 1),
        northwest: Position.new(-2, -1)
    }

    def generate!
        next_production_number_index = 0

        territories.each_with_index do |territory, index|
            territory.terrain = terrains[index]
            if territory.terrain == Terrain::DESERT
                game.robber_territory = territory
            else
                territory.production_number = production_numbers[next_production_number_index]
                next_production_number_index += 1
            end

            territory_position = Position.new(territory.x, territory.y)
            x = territory.x
            y = territory.y

            northwest_border = borders_by_position[Position.new(x - 1, y - 2)]
            north_corner = corners_by_position[territory_position + CORNER_OFFSETS[:north]]

            adjacencies.build(
                territory: territory,
                northwest_border: northwest_border,
                north_corner: north_corner
            )

            northeast_border = borders_by_position[Position.new(x + 1, y - 2)]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                north_corner: north_corner
            )

            northeast_corner = corners_by_position[territory_position + CORNER_OFFSETS[:northeast]]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                northeast_corner: northeast_corner
            )

            east_border = borders_by_position[Position.new(x + 2, y)]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                northeast_corner: northeast_corner
            )

            southeast_corner = corners_by_position[territory_position + CORNER_OFFSETS[:southeast]]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                southeast_corner: southeast_corner
            )

            southeast_border = borders_by_position[Position.new(x + 1, y + 2)]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                southeast_corner: southeast_corner
            )

            south_corner = corners_by_position[territory_position + CORNER_OFFSETS[:south]]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                south_corner: south_corner
            )

            southwest_border = borders_by_position[Position.new(x - 1, y + 2)]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                south_corner: south_corner
            )

            southwest_corner = corners_by_position[territory_position + CORNER_OFFSETS[:southwest]]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                southwest_corner: southwest_corner
            )

            west_border = borders_by_position[Position.new(x - 2, y)]

            adjacencies.build(
                territory: territory,
                west_border: west_border,
                southwest_corner: southwest_corner
            )

            northwest_corner = corners_by_position[territory_position + CORNER_OFFSETS[:northwest]]

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

        HARBOR_ORIENTATIONS.each_with_index do |harbor_orientation, index|
            Rails.logger.info harbor_offers[index]

            harbor_position = harbor_orientation[:harbor_position]
            harbor = game.harbors.build(
                x: harbor_position.x,
                y: harbor_position.y,
                harbor_offer: harbor_offers[index]
            )

            Rails.logger.info harbor
            harbor_orientation[:corner_offsets].each do |corner_offset|
                harbor.corner_harbors.build(
                    corner: corners_by_position[harbor_position + corner_offset]
                )
            end
        end
    end

    private

    TERRITORY_POSITIONS = [
        Position.new(-4, -8), Position.new(0, -8), Position.new(4, -8),
        Position.new(-6, -4), Position.new(-2, -4), Position.new(2, -4), Position.new(6, -4),
        Position.new(-8, 0), Position.new(-4, 0), Position.new(0, 0), Position.new(4, 0), Position.new(8, 0),
        Position.new(-6, 4), Position.new(-2, 4),Position.new(2, 4), Position.new(6, 4),
        Position.new(-4, 8), Position.new(0, 8), Position.new(4, 8)
    ]

    HARBOR_ORIENTATIONS = [
        {
            harbor_position: Position.new(-6, -12),
            corner_offsets: [
                CORNER_OFFSETS[:south],
                CORNER_OFFSETS[:southeast]
            ]
        },
        {
            harbor_position: Position.new(2, -12),
            corner_offsets: [
                CORNER_OFFSETS[:southwest],
                CORNER_OFFSETS[:south]
            ]
        },
        {
            harbor_position: Position.new(8, -8),
            corner_offsets: [
                CORNER_OFFSETS[:southwest],
                CORNER_OFFSETS[:south]
            ]
        },
        {
            harbor_position: Position.new(-10, -4),
            corner_offsets: [
                CORNER_OFFSETS[:northeast],
                CORNER_OFFSETS[:southeast]
            ]
        },
        {
            harbor_position: Position.new(12, 0),
            corner_offsets: [
                CORNER_OFFSETS[:northwest],
                CORNER_OFFSETS[:southwest]
            ]
        },
        {
            harbor_position: Position.new(-10, 4),
            corner_offsets: [
                CORNER_OFFSETS[:northeast],
                CORNER_OFFSETS[:southeast]
            ]
        },
        {
            harbor_position: Position.new(8, 8),
            corner_offsets: [
                CORNER_OFFSETS[:north],
                CORNER_OFFSETS[:northwest]
            ]
        },
        {
            harbor_position: Position.new(-6, 12),
            corner_offsets: [
                CORNER_OFFSETS[:north],
                CORNER_OFFSETS[:northeast]
            ]
        },
        {
            harbor_position: Position.new(2, 12),
            corner_offsets: [
                CORNER_OFFSETS[:north],
                CORNER_OFFSETS[:northwest]
            ]
        }
    ]

    def territories
        @territories ||= TERRITORY_POSITIONS.map { |position| Territory.new(x: position.x, y: position.y) }
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

    def harbor_offers
        @harbor_offers ||= HarborOffer.shuffled
    end
end
