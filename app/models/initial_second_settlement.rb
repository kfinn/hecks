class InitialSecondSettlement
    include ActiveModel::Model
    attr_accessor :player, :corner

    delegate :game, to: :player

    validate :player_must_not_already_have_initial_second_settlement
    validate :all_players_must_have_completed_initial_setup
    validate :must_be_players_turn
    validate :settlement_must_be_valid

    def save!
        raise ActiveRecord::RecordInvalid.new(self) unless valid?
        ApplicationRecord.transaction do
            settlement.save!
            update_player!
        end
    end

    def settlement
        unless instance_variable_defined?(:@settlement)
            @settlement = Settlement.new(
                player: player,
                corner: corner
            )
        end
        @settlement
    end

    private

    def player_must_not_already_have_initial_second_settlement
        errors[:player] << 'must not already have an initial settlement' if player.initial_second_settlement.present?
    end

    def all_players_must_have_completed_initial_setup
        players_without_initial_setup = game.players.without_initial_setup
        errors[:base] << 'all players must have completed initial setup' if players_without_initial_setup.any?
    end

    def must_be_players_turn
        later_players_without_initial_second_setup = player.later_players.without_initial_second_setup
        errors[:player] << "must be this player's turn" if later_players_without_initial_second_setup.any?
    end

    def settlement_must_be_valid
        unless settlement.valid?
            settlement.errors.each do |key, message|
                errors[:settlement] << "#{key}: #{message}"
            end
        end
    end

    def update_player!
        player.initial_second_settlement = settlement
        corner.territories.map(&:resource).compact.tally.each do |resource, amount|
            player.collect_resource(resource, amount)
        end
        player.save!
    end
end
