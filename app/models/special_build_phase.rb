class SpecialBuildPhase < ApplicationRecord
    belongs_to :player
    belongs_to :turn

    validates :player, uniqueness: { scope: :turn_id }

    def self.ordered_after_player(player)
        total_players = player.game.players.size
        starting_player_ordering = player.ordering

        joins(:player)
            .order(Arel.sql(<<~SQL.squish))
                (
                    players.ordering +
                        - #{starting_player_ordering}
                        + #{total_players}
                ) % #{total_players}
            SQL
    end

    def self.next_for_repeating_turn(repeating_turn)
        ordered_after_player(repeating_turn.player).first
    end
end
