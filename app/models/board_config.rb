class BoardConfig < ActiveHash::Base
    include ActiveHash::Enum
    enum_accessor :id

    self.data = [
        {
            id: 'small',
            min_players: 2,
            max_players: 4,
            allows_special_build_phase: false,
            territory_positions: [
                Position.new(-4, -8), Position.new(0, -8), Position.new(4, -8),
                Position.new(-6, -4), Position.new(-2, -4), Position.new(2, -4), Position.new(6, -4),
                Position.new(-8, 0), Position.new(-4, 0), Position.new(0, 0), Position.new(4, 0), Position.new(8, 0),
                Position.new(-6, 4), Position.new(-2, 4),Position.new(2, 4), Position.new(6, 4),
                Position.new(-4, 8), Position.new(0, 8), Position.new(4, 8)
            ],
            harbor_orientations: [
                HarborOrientation.new(Position.new(-6, -12), [:south, :southeast]),
                HarborOrientation.new(Position.new(2, -12), [:southwest, :south]),
                HarborOrientation.new(Position.new(8, -8), [:southwest, :south]),
                HarborOrientation.new(Position.new(-10, -4), [:northeast, :southeast]),
                HarborOrientation.new(Position.new(12, 0), [:northwest, :southwest]),
                HarborOrientation.new(Position.new(-10, 4), [:northeast, :southeast]),
                HarborOrientation.new(Position.new(8, 8), [:north, :northwest]),
                HarborOrientation.new(Position.new(-6, 12), [:north, :northeast]),
                HarborOrientation.new(Position.new(2, 12), [:north, :northwest])
            ],
            terrain_counts_by_terrain: {
                Terrain::DESERT => 1,
                Terrain::FIELDS => 4,
                Terrain::PASTURE => 4,
                Terrain::FOREST => 4,
                Terrain::MOUNTAINS => 3,
                Terrain::HILLS => 3
            },
            production_number_counts_by_production_number: {
                ProductionNumber::TWO => 1,
                ProductionNumber::THREE => 2,
                ProductionNumber::FOUR => 2,
                ProductionNumber::FIVE => 2,
                ProductionNumber::SIX => 2,
                ProductionNumber::EIGHT => 2,
                ProductionNumber::NINE => 2,
                ProductionNumber::TEN => 2,
                ProductionNumber::ELEVEN => 2,
                ProductionNumber::TWELVE => 1
            },
            development_card_behavior_counts_by_development_card_behavior: {
                DevelopmentCardBehavior::KNIGHT => 14,
                DevelopmentCardBehavior::VICTORY_POINT => 5,
                DevelopmentCardBehavior::MONOPOLY => 2,
                DevelopmentCardBehavior::ROAD_BUILDING => 2,
                DevelopmentCardBehavior::YEAR_OF_PLENTY => 2
            },
            harbor_offer_counts_by_harbor_offer: {
                HarborOffer::GENERIC_OFFER => 4,
                HarborOffer::BRICK_OFFER => 1,
                HarborOffer::GRAIN_OFFER => 1,
                HarborOffer::LUMBER_OFFER => 1,
                HarborOffer::ORE_OFFER => 1,
                HarborOffer::WOOL_OFFER => 1
            }
        }, {
            id: 'large',
            min_players: 3,
            max_players: 6,
            allows_special_build_phase: true,
            territory_positions: [
                Position.new(-4, -12), Position.new(0, -12), Position.new(4, -12),
                Position.new(-6, -8), Position.new(-2, -8), Position.new(2, -8), Position.new(6, -8),
                Position.new(-8, -4), Position.new(-4, -4), Position.new(0, -4), Position.new(4, -4), Position.new(8, -4),
                Position.new(-10, 0), Position.new(-6, 0), Position.new(-2, 0),Position.new(2, 0), Position.new(6, 0), Position.new(10, 0),
                Position.new(-8, 4), Position.new(-4, 4), Position.new(0, 4), Position.new(4, 4), Position.new(8, 4),
                Position.new(-6, 8), Position.new(-2, 8), Position.new(2, 8), Position.new(6, 8),
                Position.new(-4, 12), Position.new(0, 12), Position.new(4, 12)
            ],
            harbor_orientations: [
                HarborOrientation.new(Position.new(-6, -16), [:south, :southeast]),
                HarborOrientation.new(Position.new(2, -16), [:southwest, :south]),
                HarborOrientation.new(Position.new(8, -12), [:southwest, :south]),
                HarborOrientation.new(Position.new(-12, -4), [:northeast, :southeast]),
                HarborOrientation.new(Position.new(14, 0), [:northwest, :southwest]),
                HarborOrientation.new(Position.new(-12, 4), [:northeast, :southeast]),
                HarborOrientation.new(Position.new(-10, 8), [:northeast, :southeast]),
                HarborOrientation.new(Position.new(10, 8), [:north, :northwest]),
                HarborOrientation.new(Position.new(8, 12), [:northwest, :southwest]),
                HarborOrientation.new(Position.new(-6, 16), [:north, :northeast]),
                HarborOrientation.new(Position.new(2, 16), [:north, :northwest])
            ],
            terrain_counts_by_terrain: {
                Terrain::DESERT => 2,
                Terrain::FIELDS => 6,
                Terrain::PASTURE => 6,
                Terrain::FOREST => 6,
                Terrain::MOUNTAINS => 5,
                Terrain::HILLS => 5
            },
            production_number_counts_by_production_number: {
                ProductionNumber::TWO => 2,
                ProductionNumber::THREE => 3,
                ProductionNumber::FOUR => 3,
                ProductionNumber::FIVE => 3,
                ProductionNumber::SIX => 3,
                ProductionNumber::EIGHT => 3,
                ProductionNumber::NINE => 3,
                ProductionNumber::TEN => 3,
                ProductionNumber::ELEVEN => 3,
                ProductionNumber::TWELVE => 2
            },
            development_card_behavior_counts_by_development_card_behavior: {
                DevelopmentCardBehavior::KNIGHT => 20,
                DevelopmentCardBehavior::VICTORY_POINT => 5,
                DevelopmentCardBehavior::MONOPOLY => 3,
                DevelopmentCardBehavior::ROAD_BUILDING => 3,
                DevelopmentCardBehavior::YEAR_OF_PLENTY => 3
            },
            harbor_offer_counts_by_harbor_offer: {
                HarborOffer::GENERIC_OFFER => 5,
                HarborOffer::BRICK_OFFER => 1,
                HarborOffer::GRAIN_OFFER => 1,
                HarborOffer::LUMBER_OFFER => 1,
                HarborOffer::ORE_OFFER => 1,
                HarborOffer::WOOL_OFFER => 2
            }
        }
    ]

    alias allows_special_build_phase? allows_special_build_phase

    def shuffled_terrains
        terrains = terrain_counts_by_terrain.flat_map do |terrain, count|
            Array.new(count, terrain)
        end
        terrains.shuffle
    end

    def shuffled_production_numbers
        production_numbers = production_number_counts_by_production_number.flat_map do |production_number, count|
            Array.new(count, production_number)
        end
        production_numbers.shuffle
    end

    def shuffled_development_card_behaviors
        development_card_behaviors = development_card_behavior_counts_by_development_card_behavior.flat_map do |development_card_behavior, count|
            Array.new(count, development_card_behavior)
        end
        development_card_behaviors.shuffle
    end

    def shuffled_harbor_offers
        harbor_offers = harbor_offer_counts_by_harbor_offer.flat_map do |harbor_offer, count|
            Array.new(count, harbor_offer)
        end
        harbor_offers.shuffle
    end
end
