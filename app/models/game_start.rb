class GameStart
    include ActiveModel::Model
    attr_accessor :game

    validate :must_have_enough_players
    validate :game_must_not_be_started

    delegate :players, to: :game

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            update_players!
            update_game!
        end
    end

    private

    def game_must_not_be_started
        errors[:game] << 'already started' if game.started?
    end

    def must_have_enough_players
        errors[:game] << 'not enough players' unless players.size >= game.min_players && players.size <= game.max_players
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
