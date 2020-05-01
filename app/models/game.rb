class Game < ApplicationRecord
    has_many :adjacencies

    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

    before_create :generate!

    def generate!
        center_territory = Territory.new(distance_from_center: 0, offset_from_north: 0)
        center_borders = (0..5).map { Border.new }
        center_corners = (0..5).map { Corner.new }

        ring_1_territories = (0..5).map { |offset| Territory.new(distance_from_center: 1, offset_from_north: offset) }
        ring_1_mid_borders = (0..5).map { Border.new }
        ring_1_mid_corners = (0..5).map { Corner.new }

        ring_1_outer_borders = (0..17).map { Border.new }
        ring_1_outer_corners = (0..11).map { Corner.new }

        ring_2_vertex_territories = (0..5).map do |offset|
            Territory.new(distance_from_center: 2, offset_from_north: (offset * 2))
        end
        ring_2_vertex_mid_borders = (0..5).map { Border.new }
        ring_2_vertex_mid_corners = (0..5).map { Corner.new }
        ring_2_vertex_outer_borders = (0..17).map { Border.new }
        ring_2_vertex_outer_corners = (0..11).map { Corner.new }

        ring_2_edge_territories = (0..5).map do |offset|
             Territory.new(distance_from_center: 2, offset_from_north: ((offset * 2) + 1))
        end
        ring_2_edge_mid_borders = (0..5).map { Border.new }
        ring_2_edge_mid_corners = (0..5).map { Corner.new }
        ring_2_edge_outer_borders = (0..11).map { Border.new }
        ring_2_edge_outer_corners = (0..5).map { Corner.new }

        (0..5).each do |index|
            center_border = center_borders[index]
            center_corner_1 = center_corners[index]
            center_corner_2 = center_corners[(index + 1) % 6]

            adjacencies.build(
                territory: center_territory,
                border: center_border,
                corner: center_corner_1
            )

            adjacencies.build(
                territory: center_territory,
                border: center_border,
                corner: center_corner_2
            )

            ring_1_territory = ring_1_territories[index]

            adjacencies.build(
                territory: ring_1_territory,
                border: center_border,
                corner: center_corner_1
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: center_border,
                corner: center_corner_2
            )

            ring_1_mid_border_1 = ring_1_mid_borders[index]
            ring_1_mid_border_2 = ring_1_mid_borders[(index + 1) % 6]
            ring_1_mid_corner_1 = ring_1_mid_corners[index]
            ring_1_mid_corner_2 = ring_1_mid_corners[(index + 1) % 6]

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_mid_border_1,
                corner: center_corner_1
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_mid_border_1,
                corner: ring_1_mid_corner_1
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_mid_border_2,
                corner: center_corner_2
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_mid_border_2,
                corner: ring_1_mid_corner_2
            )

            ring_1_outer_border_1 = ring_1_outer_borders[index * 3]
            ring_1_outer_border_2 = ring_1_outer_borders[index * 3 + 1]
            ring_1_outer_border_3 = ring_1_outer_borders[index * 3 + 2]

            ring_1_outer_corner_1 = ring_1_outer_corners[index * 2]
            ring_1_outer_corner_2 = ring_1_outer_corners[index * 2 + 1]

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_outer_border_1,
                corner: ring_1_mid_corner_1
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_outer_border_1,
                corner: ring_1_outer_corner_1
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_outer_border_2,
                corner: ring_1_outer_corner_1
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_outer_border_2,
                corner: ring_1_outer_corner_2
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_outer_border_3,
                corner: ring_1_outer_corner_2
            )

            adjacencies.build(
                territory: ring_1_territory,
                border: ring_1_outer_border_3,
                corner: ring_1_mid_corner_2
            )


            # 24 to go
            ring_2_vertex_territory = ring_2_vertex_territories[index]
            ring_2_vertex_mid_border_1 = ring_2_vertex_mid_borders[index]
            ring_2_vertex_mid_corner_1 = ring_2_vertex_mid_corners[index]

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_1_outer_border_2,
                corner: ring_1_outer_corner_1,
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_vertex_mid_border_1,
                corner: ring_1_outer_corner_1
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_vertex_mid_border_1,
                corner: ring_2_vertex_mid_corner_1
            )

            ring_2_vertex_outer_border_1 = ring_2_vertex_outer_borders[index * 3]
            ring_2_vertex_outer_border_2 = ring_2_vertex_outer_borders[(index * 3) + 1]
            ring_2_vertex_outer_border_3 = ring_2_vertex_outer_borders[(index * 3) + 2]

            ring_2_vertex_outer_corner_1 = ring_2_vertex_outer_corners[index * 2]
            ring_2_vertex_outer_corner_2 = ring_2_vertex_outer_corners[(index * 2) + 1]

            ring_2_edge_mid_border = ring_2_edge_mid_borders[index]
            ring_2_edge_mid_corner = ring_2_edge_mid_corners[index]

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_vertex_outer_border_1,
                corner: ring_2_vertex_mid_corner_1
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_vertex_outer_border_1,
                corner: ring_2_vertex_outer_corner_1
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_vertex_outer_border_2,
                corner: ring_2_vertex_outer_corner_1
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_vertex_outer_border_2,
                corner: ring_2_vertex_outer_corner_2
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_vertex_outer_border_3,
                corner: ring_2_vertex_outer_corner_2
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_vertex_outer_border_3,
                corner: ring_2_edge_mid_corner
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_edge_mid_border,
                corner: ring_2_edge_mid_corner
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_2_edge_mid_border,
                corner: ring_1_outer_corner_2
            )

            adjacencies.build(
                territory: ring_2_vertex_territory,
                border: ring_1_outer_border_2,
                corner: ring_1_outer_corner_2
            )

            ring_2_edge_territory = ring_2_edge_territories[index]

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_2_edge_mid_border,
                corner: ring_1_outer_corner_2
            )

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_2_edge_mid_border,
                corner: ring_2_edge_mid_corner
            )

            ring_2_edge_outer_border_1 = ring_2_edge_outer_borders[index * 2]
            ring_2_edge_outer_border_2 = ring_2_edge_outer_borders[(index * 2) + 1]
            ring_2_edge_outer_corner = ring_2_edge_outer_corners[index]

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_2_edge_outer_border_1,
                corner: ring_2_edge_mid_corner
            )

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_2_edge_outer_border_1,
                corner: ring_2_edge_outer_corner
            )

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_2_edge_outer_border_2,
                corner: ring_2_edge_outer_corner
            )

            ring_2_vertex_mid_corner_2 = ring_2_vertex_mid_corners[(index + 1) % 6]

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_2_edge_outer_border_2,
                corner: ring_2_vertex_mid_corner_2
            )

            ring_2_vertex_mid_border_2 = ring_2_vertex_mid_borders[(index + 1) % 6]

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_2_vertex_mid_border_2,
                corner: ring_2_vertex_mid_corner_2
            )

            ring_1_outer_corner_1_2 = ring_1_outer_corners[((index + 1) % 6) * 2]

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_2_vertex_mid_border_2,
                corner: ring_1_outer_corner_1_2
            )

            ring_1_outer_border_1_2 = ring_1_outer_borders[((index + 1) % 6) * 3]

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_1_outer_border_1_2,
                corner: ring_1_outer_corner_1_2
            )

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_1_outer_border_1_2,
                corner: ring_1_mid_corner_2
            )

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_1_outer_border_3,
                corner: ring_1_mid_corner_2
            )

            adjacencies.build(
                territory: ring_2_edge_territory,
                border: ring_1_outer_border_3,
                corner: ring_1_outer_corner_2
            )
        end
    end
end
