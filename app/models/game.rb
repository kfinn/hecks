class Game < ApplicationRecord
    has_many :adjacencies

    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

    before_create :generate!

    Position = Struct.new(:x, :y)

    def generate!
        rows = [
            { y: -2, x_range: -2..0 },
            { y: -1, x_range: -2..1 },
            { y: 0, x_range: -2..2 },
            { y: 1, x_range: -1..2 },
            { y: 2, x_range: 0..2 }
        ]

        generated_territories = []

        rows.each do |row|
            y = row[:y]
            row[:x_range].each do |x|
                generated_territories << Territory.new(x: x, y: y)
            end
        end

        generated_borders_by_position = Hash.new { |hash, position| hash[position] = Border.new(x: position.x, y: position.y) }
        generated_corners_by_position  = Hash.new { |hash, position| hash[position] = Corner.new(x: position.x, y: position.y) }

        generated_terrains = Terrain.shuffled
        generated_production_numbers = ProductionNumber.shuffled
        next_production_number_index = 0

        generated_territories.each_with_index do |territory, index|
            territory.terrain = generated_terrains[index]
            if territory.terrain != Terrain::DESERT
                territory.production_number = generated_production_numbers[next_production_number_index]
                next_production_number_index += 1
            end

            x = territory.x
            y = territory.y

            northwest_border = generated_borders_by_position[Position.new(2 * x, 2 * y)]
            north_corner = generated_corners_by_position[Position.new(2 * x, 2 * y)]

            adjacencies.build(
                territory: territory,
                northwest_border: northwest_border,
                north_corner: north_corner
            )

            northeast_border = generated_borders_by_position[Position.new(2 * x + 1, 2 * y)]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                north_corner: north_corner
            )

            northeast_corner = generated_corners_by_position[Position.new(2 * x + 1, 2 * y)]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                northeast_corner: northeast_corner
            )

            east_border = generated_borders_by_position[Position.new(2 * x + 2, 2 * y + 1)]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                northeast_corner: northeast_corner
            )

            southeast_corner = generated_corners_by_position[Position.new(2 * x + 1, 2 * y + 1)]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                southeast_corner: southeast_corner
            )

            southeast_border = generated_borders_by_position[Position.new(2 * x + 2, 2 * y + 2)]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                southeast_corner: southeast_corner
            )

            south_corner = generated_corners_by_position[Position.new(2 * x + 1, 2 * y + 2)]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                south_corner: south_corner
            )

            southwest_border = generated_borders_by_position[Position.new(2 * x + 1, 2 * y + 2)]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                south_corner: south_corner
            )

            southwest_corner = generated_corners_by_position[Position.new(2 * x, 2 * y + 2)]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                southwest_corner: southwest_corner
            )

            west_border = generated_borders_by_position[Position.new(2 * x, 2 * y + 1)]

            adjacencies.build(
                territory: territory,
                west_border: west_border,
                southwest_corner: southwest_corner
            )

            northwest_corner = generated_corners_by_position[Position.new(2 * x, 2 * y + 1)]

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
end
