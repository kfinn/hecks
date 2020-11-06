class SpecialBuildPhase < ApplicationRecord
    include GameChanging

    belongs_to :player
    belongs_to :turn
    has_one :game, through: :player
    has_one :special_build_phase_turn

    validates :player, uniqueness: { scope: :turn_id }
    validate :player_must_not_equal_turn_player
    validate :turn_must_be_repeating_turn
    validate :player_ordering_must_not_be_too_late

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

    def turn_must_be_repeating_turn
        errors[:turn] << 'cannot be a repeating turn' unless turn.type == RepeatingTurn.name
    end

    def player_ordering_must_not_be_too_late
        last_special_build_phase_turn = turn.special_build_phase_turns.order(:created_at).last
        
        return unless turn.special_build_phase_turns.present?
        return if player.ordering < turn.player.ordering || player.ordering > last_special_build_phase_turn.player.ordering

        errors[:player] << 'no longer eligible for a sepcial build phase this turn' 
    end
end
