class RoadTraversal
    include ActiveModel::Model
    attr_accessor :player, :roads

    def length
        roads.size
    end

    def since
        @since ||= roads.map(&:created_at).max
    end

    def <=>(other)
        if length != other.length
            length <=> other.length
        else
            -(since <=> other.since)
        end
    end

    def self.longest_for_player(player)
        road_traversal_cache = RoadTraversalCache.new(player)

        potential_longest_road_traversals = Corner.reachable_by(player).map do |corner|
            new(
                player: player,
                roads: longest_road_set_from_corner(road_traversal_cache, corner)
            )
        end

        potential_longest_road_traversals.max
    end

    def self.longest_road_set_from_corner(road_traversal_cache, corner, visited_roads = Set.new)
        traversible_roads = road_traversal_cache.traversible_roads_by_corner[corner] - visited_roads.to_a

        settlement_player_id = road_traversal_cache.settlement_player_ids_by_corner[corner]
        corner_occupied_by_other_player = settlement_player_id.present? && settlement_player_id != road_traversal_cache.player.id

        if (corner_occupied_by_other_player && visited_roads.any?) || traversible_roads.none?
            visited_roads
        else
            adjancent_longest_roads = traversible_roads.map do |adjacent_road|
                adjacent_corner = (road_traversal_cache.corners_by_road[adjacent_road] - [corner]).first
                longest_road_set_from_corner(road_traversal_cache, adjacent_corner, visited_roads | [adjacent_road])
            end

            adjancent_longest_roads.max_by(&:size)
        end
    end

    class RoadTraversalCache
        def initialize(player)
            @player = player
        end

        attr_reader :player

        def traversible_roads_by_corner
            @traversible_roads_by_corner ||= Corner.reachable_by(player).includes(:roads, :settlement).each_with_object({}) do |corner, acc|
                acc[corner] = corner.roads.select { |road| road.player_id == player.id }
            end
        end

        def corners_by_road
            @corners_by_road ||= traversible_roads_by_corner.each_with_object({}) do |(corner, roads), acc|
                roads.each do |road|
                    acc[road] ||= []
                    acc[road] << corner
                end
            end
        end

        def settlement_player_ids_by_corner
            @settlement_player_ids_by_corner ||= Corner.reachable_by(player).includes(:settlement).each_with_object({}) do |corner, acc|
                acc[corner] = corner.settlement&.player_id
            end
        end
    end
end
