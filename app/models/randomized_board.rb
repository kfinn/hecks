class RandomizedBoard
    include ActiveModel::Model

    attr_accessor :game

    delegate :adjacencies, :harbors, :board_config, to: :game
    delegate :territory_positions, :harbor_orientations, to: :board_config

    def generate!
        territories.each_with_index do |territory, index|
            territory.terrain = terrains[index]
            if territory.terrain == Terrain::DESERT
                game.robber_territory = territory
            end

            territory_position = territory.position

            northwest_border = borders_by_position[territory_position.northwest_border_position]
            north_corner = corners_by_position[territory_position.north_corner_position]

            adjacencies.build(
                territory: territory,
                northwest_border: northwest_border,
                north_corner: north_corner
            )

            northeast_border = borders_by_position[territory_position.northeast_border_position]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                north_corner: north_corner
            )

            northeast_corner = corners_by_position[territory_position.northeast_corner_position]

            adjacencies.build(
                territory: territory,
                northeast_border: northeast_border,
                northeast_corner: northeast_corner
            )

            east_border = borders_by_position[territory_position.east_border_position]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                northeast_corner: northeast_corner
            )

            southeast_corner = corners_by_position[territory_position.southeast_corner_position]

            adjacencies.build(
                territory: territory,
                east_border: east_border,
                southeast_corner: southeast_corner
            )

            southeast_border = borders_by_position[territory_position.southeast_border_position]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                southeast_corner: southeast_corner
            )

            south_corner = corners_by_position[territory_position.south_corner_position]

            adjacencies.build(
                territory: territory,
                southeast_border: southeast_border,
                south_corner: south_corner
            )

            southwest_border = borders_by_position[territory_position.southwest_border_position]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                south_corner: south_corner
            )

            southwest_corner = corners_by_position[territory_position.southwest_corner_position]

            adjacencies.build(
                territory: territory,
                southwest_border: southwest_border,
                southwest_corner: southwest_corner
            )

            west_border = borders_by_position[territory_position.west_border_position]

            adjacencies.build(
                territory: territory,
                west_border: west_border,
                southwest_corner: southwest_corner
            )

            northwest_corner = corners_by_position[territory_position.northwest_corner_position]

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
                    territory.position.neighboring_territory_positions.none? do |neighboring_territory_position|
                        territories_by_position[neighboring_territory_position]&.production_number&.high_frequency?
                    end
            end
            available_territories.sample.production_number = production_number
        end

        low_frequency_production_numbers.each do |production_number|
            available_territories = territories.select do |territory|
                territory.terrain.production? &&
                    territory.production_number.blank? &&
                    territory.position.neighboring_territory_positions.none? do |neighboring_territory_position|
                        neighbor = territories_by_position[neighboring_territory_position]
                        neighbor&.production_number&.low_frequency? || neighbor&.terrain&.desert?
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

        harbor_orientations.each_with_index do |harbor_orientation, index|
            harbor = Harbor.new(
                x: harbor_orientation.position.x,
                y: harbor_orientation.position.y,
                harbor_offer: harbor_offers[index]
            )

            harbor_orientation.corner_positions.each do |corner_position|
                corners_by_position[corner_position].build_corner_harbor(
                    harbor: harbor
                )
            end
        end
    end

    private

    def territories
        territories_by_position.values
    end

    def territories_by_position
        @territories_by_position ||= territory_positions.each_with_object({}) do |position, acc|
            acc[position] = Territory.new(x: position.x, y: position.y)
        end
    end

    def terrains
        @terrains ||= board_config.shuffled_terrains
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
        @production_numbers ||= board_config.shuffled_production_numbers
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
        @harbor_offers ||= board_config.shuffled_harbor_offers
    end
end
