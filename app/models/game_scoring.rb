class GameScoring
    def initialize(game)
        @game = game
    end

    attr_reader :game

    delegate :players, to: :game

    def scores_by_player
        @scores_by_player = Hash.new do |hash, player|
            hash[player] =
                settlement_scores_by_player[player] +
                (player_with_longest_road == player ? 2 : 0) +
                (player_with_largest_army == player ? 2 : 0)
        end
    end

    def settlement_scores_by_player
        @settlement_scores_by_player ||= players.each_with_object({}) do |player, acc|
            acc[player] = player.settlements.without_city_upgrade.size + (player.settlements.with_city_upgrade.size * 2)
        end
    end

    def player_with_largest_army
        unless instance_variable_defined?(:@player_with_largest_army)
            @player_with_largest_army = players
                .eligible_for_largest_army
                .order(army_size: :desc, army_since: :asc)
                .first
        end
        @player_with_largest_army
    end

    def player_with_longest_road
        unless instance_variable_defined?(:@player_with_longest_road)
            @player_with_longest_road = players
                .eligible_for_longest_road
                .order(longest_road_traversal_length: :desc, longest_road_traversal_since: :asc)
                .first
        end
        @player_with_longest_road
    end

    def secret_scores_by_player
        @secret_scores_by_player ||= players.each_with_object({}) do |player, acc|
            acc[player] = scores_by_player[player] + player.victory_point_cards.size
        end
    end

    def winner
        unless instance_variable_defined?(:@winner)
            @winner = secret_scores_by_player.select { |player, score| score >= 10 }.first&.first
        end
        @winner
    end
end
