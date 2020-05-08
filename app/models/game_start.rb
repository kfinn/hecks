class GameStart
    include ActiveModel::Model
    attr_accessor :game

    validate :must_have_enough_players

    delegate :players, to: :game

    def save!
        raise ActiveRecord::RecordInvalid.new(self) unless valid?
        ApplicationRecord.transaction do
            update_players!
            update_game!
        end
    end

    private

    def must_have_enough_players
        errors[:game] << 'not enough players' unless players.size >= 2
    end

    def update_players!
        players.each do |player|
            player.update!(
                ordering_roll: distinct_ordering_rolls_by_player[player],
                ordering: orderings_by_player[player]
            )
        end
    end

    def distinct_ordering_rolls_by_player
        @distinct_ordering_rolls_by_player ||= players.each_with_object({}) do |player, acc|
            roll = Roll.new
            while acc.values.map(&:value).include?(roll.value)
                roll.roll!
            end
            acc[player] = roll
        end
    end

    def orderings_by_player
        unless instance_variable_defined?(:@orderings_by_player)
            @orderings_by_player = {}
            players_sorted_by_ordering_roll.each_with_index do |player, index|
                @orderings_by_player[player] = index
            end
        end
        @orderings_by_player
    end

    def players_sorted_by_ordering_roll
        @players_sorted_by_ordering_roll ||= players.sort_by { |player| (-distinct_ordering_rolls_by_player[player].value) }
    end

    def update_game!
        game.update!(
            started_at: Time.zone.now,
            current_turn: InitialSetupTurn.new(game: game, player: players_sorted_by_ordering_roll.first)
        )
    end
end
