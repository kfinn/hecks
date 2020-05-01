module TerritoryHelper
    HEX_SCALE = 50

    def territory_center_x(territory)
        (territory.x + territory.y * Math.cos(2 * Math::PI / 3)) * 2 * HEX_SCALE
    end

    def territory_center_y(territory)
        (territory.y * Math.sin(2 * Math::PI / 3)) * 2 * HEX_SCALE
    end

    def territory_polygon_points(territory)
        angles = (0..5).map { |pi_thirds| pi_thirds * Math::PI / 3 }
        normalized_point_pairs = angles.map do |angle|
            [
                Math.sin(angle),
                Math.cos(angle)
            ]
        end
        screen_point_pairs = normalized_point_pairs.map do |x, y|
            [
                x * HEX_SCALE + territory_center_x(territory),
                y * HEX_SCALE + territory_center_y(territory)
            ]
        end
        screen_points = screen_point_pairs.flatten
        rounded_screen_points = screen_points.map { |unrounded| unrounded.round }

        rounded_screen_points.join(' ')
    end
end
