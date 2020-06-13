class SpecialBuildPhase < ApplicationRecord
    include GameChanging

    belongs_to :player
    belongs_to :turn
    has_one :game, through: :player

    validates :player, uniqueness: { scope: :turn_id }
    validate :player_must_not_equal_turn_player

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

    def self.incomplete
        where.not(id: SpecialBuildPhaseTurn.all.select(:special_build_phase_id))
    end

    private

    def player_must_not_equal_turn_player
        errors[:player] << 'not eligible for a special bulid phase this turn' if turn.player == player
    end
end
