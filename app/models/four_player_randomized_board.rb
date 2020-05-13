class FourPlayerRandomizedBoard
    include ActiveModel::Model

    attr_accessor :game

    delegate :adjacencies, :harbors, to: :game

    Position = Struct.new(:x, :y) do
        def +(other)
            Position.new(x + other.x, y + other.y)
        end
    end

    TERRITORY_CORNER_OFFSETS = {
        north: Position.new(0, -3),
        northeast: Position.new(2, -1),
        southeast: Position.new(2, 1),
        south: Position.new(0, 3),
        southwest: Position.new(-2, 1),
        northwest: Position.new(-2, -1)
    }

    TERRITORY_BORDER_OFFSETS = {
        northwest: Position.new(-1, -2),
        northeast: Position.new(1, -2),
        east: Position.new(2, 0),
        southeast: Position.new(1, 2),
        southwest: Position.new(-1, 2),
        west: Position.new(-2, 0)
    }

    TERRITORY_NEIGHBOR_OFFSETS = {
        northwest: Position.new(-2, -4),
        northeast: Position.new(2, -4),
        east: Position.new(4, 0),
        southeast: Position.new(2, 4),
        southwest: Position.new(-2, 4),
        west: Position.new(-4, 0)
    }

    def generate!
        territories.each_with_index do |territory, index|
            territory.terrain = terrains[index]
            if territory.terrain == Terrain::DESERT
                game.robber_territory = territory
            end

            territory_position = Position.new(territory.x, territory.y)
            x = territory.x
            y = territory.y

            northwest_border = borders_by_position[territory_position + TERRITORY_BORDER_OFFSETS[:northwest]]
            north_corner = corners_by_position[territory_position + TERRITORY_CORNER_OFFSETS[:north]]

            adjacencies.build(
                territory: territory,
                northwest_border: northwest_border,
                north_corner: north_corner
            )

            northeast_border = borders_by_position[territory_position + TERRITORY_BORDER_OFFSETS[:northeast]]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                north_corner: north_corner
            )

            northeast_corner = corners_by_position[territory_position + TERRITORY_CORNER_OFFSETS[:northeast]]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                northeast_corner: northeast_corner
            )

            east_border = borders_by_position[territory_position + TERRITORY_BORDER_OFFSETS[:east]]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                northeast_corner: northeast_corner
            )

            southeast_corner = corners_by_position[territory_position + TERRITORY_CORNER_OFFSETS[:southeast]]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                southeast_corner: southeast_corner
            )

            southeast_border = borders_by_position[territory_position + TERRITORY_BORDER_OFFSETS[:southeast]]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                southeast_corner: southeast_corner
            )

            south_corner = corners_by_position[territory_position + TERRITORY_CORNER_OFFSETS[:south]]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                south_corner: south_corner
            )

            southwest_border = borders_by_position[territory_position + TERRITORY_BORDER_OFFSETS[:southwest]]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                south_corner: south_corner
            )

            southwest_corner = corners_by_position[territory_position + TERRITORY_CORNER_OFFSETS[:southwest]]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                southwest_corner: southwest_corner
            )

            west_border = borders_by_position[territory_position + TERRITORY_BORDER_OFFSETS[:west]]

            adjacencies.build(
                territory: territory,
                west_border: west_border,
                southwest_corner: southwest_corner
            )

            northwest_corner = corners_by_position[territory_position + TERRITORY_CORNER_OFFSETS[:northwest]]

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

        high_frequency_production_numbers.each do |production_number|
            available_territories = territories.select do |territory|
                territory.terrain.production? &&
                    territory.production_number.blank? &&
                    TERRITORY_NEIGHBOR_OFFSETS.values.none? do |neighbor_offset|
                        territories_by_position[Position.new(territory.x, territory.y) + neighbor_offset]&.production_number&.high_frequency?
                    end
            end
            available_territories.sample.production_number = production_number
        end

        low_frequency_production_numbers.each do |production_number|
            available_territories = territories.select do |territory|
                territory.terrain.production? &&
                    territory.production_number.blank? &&
                    TERRITORY_NEIGHBOR_OFFSETS.values.none? do |neighbor_offset|
                        neighbor = territories_by_position[Position.new(territory.x, territory.y) + neighbor_offset]
                        neighbor&.production_number&.low_frequency? || (neighbor&.terrain&.desert?)
                    end
            end
            available_territories.sample.production_number = production_number
        end

        mid_frequency_production_numbers.each do |production_number|
            available_territories = territories.select do |territory|
                territory.terrain.production? && territory.production_number.blank?
            end
            available_territories.sample.production_number = production_number
        end

        HARBOR_ORIENTATIONS.each_with_index do |harbor_orientation, index|
            harbor_position = harbor_orientation[:harbor_position]
            harbor = Harbor.new(
                x: harbor_position.x,
                y: harbor_position.y,
                harbor_offer: harbor_offers[index]
            )

            harbor_orientation[:corner_offsets].each do |corner_offset|
                corners_by_position[harbor_position + corner_offset].build_corner_harbor(
                    harbor: harbor
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
                TERRITORY_CORNER_OFFSETS[:south],
                TERRITORY_CORNER_OFFSETS[:southeast]
            ]
        },
        {
            harbor_position: Position.new(2, -12),
            corner_offsets: [
                TERRITORY_CORNER_OFFSETS[:southwest],
                TERRITORY_CORNER_OFFSETS[:south]
            ]
        },
        {
            harbor_position: Position.new(8, -8),
            corner_offsets: [
                TERRITORY_CORNER_OFFSETS[:southwest],
                TERRITORY_CORNER_OFFSETS[:south]
            ]
        },
        {
            harbor_position: Position.new(-10, -4),
            corner_offsets: [
                TERRITORY_CORNER_OFFSETS[:northeast],
                TERRITORY_CORNER_OFFSETS[:southeast]
            ]
        },
        {
            harbor_position: Position.new(12, 0),
            corner_offsets: [
                TERRITORY_CORNER_OFFSETS[:northwest],
                TERRITORY_CORNER_OFFSETS[:southwest]
            ]
        },
        {
            harbor_position: Position.new(-10, 4),
            corner_offsets: [
                TERRITORY_CORNER_OFFSETS[:northeast],
                TERRITORY_CORNER_OFFSETS[:southeast]
            ]
        },
        {
            harbor_position: Position.new(8, 8),
            corner_offsets: [
                TERRITORY_CORNER_OFFSETS[:north],
                TERRITORY_CORNER_OFFSETS[:northwest]
            ]
        },
        {
            harbor_position: Position.new(-6, 12),
            corner_offsets: [
                TERRITORY_CORNER_OFFSETS[:north],
                TERRITORY_CORNER_OFFSETS[:northeast]
            ]
        },
        {
            harbor_position: Position.new(2, 12),
            corner_offsets: [
                TERRITORY_CORNER_OFFSETS[:north],
                TERRITORY_CORNER_OFFSETS[:northwest]
            ]
        }
    ]

    def territories
        territories_by_position.values
    end

    def territories_by_position
        @territories_by_position ||= TERRITORY_POSITIONS.each_with_object({}) do |position, acc|
            acc[position] = Territory.new(x: position.x, y: position.y)
        end
    end

    def terrains
        @terrains ||= Terrain.shuffled
    end

    def high_frequency_production_numbers
        @high_frequency_production_numbers ||= production_numbers.select(&:high_frequency?)
    end

    def low_frequency_production_numbers
        @low_frequency_production_numbers ||= production_numbers.select(&:low_frequency?)
    end

    def mid_frequency_production_numbers
        @mid_frequency_production_numbers ||= production_numbers.reject(&:high_frequency?).reject(&:low_frequency?)
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
