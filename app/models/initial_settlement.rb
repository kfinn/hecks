class InitialSettlement
    include ActiveModel::Model
    attr_accessor :player, :corner

    delegate :game, to: :player

    validate :player_must_not_already_have_initial_settlement
    validate :must_be_players_turn
    validate :settlement_must_be_valid

    def save
        valid? && settlement.save && player.save
    end

    def settlement
        unless instance_variable_defined?(:@settlement)
            @settlement = Settlement.new(
                player: player,
                corner: corner
            )
            player.initial_settlement = @settlement
        end
        @settlement
    end

    private

    def player_must_not_already_have_initial_settlement
        errors[:player] << 'must not already have an initial settlement' if player.initial_settlement.present?
    end

    def must_be_players_turn
        earlier_players_without_initial_setup = player.earlier_players.without_initial_setup
        errors[:player] << "must be this player's turn" if earlier_players_without_initial_setup.any?
    end

    def settlement_must_be_valid
        unless settlement.valid?
            settlement.errors.each do |key, message|
                errors[:settlement] << "#{key}: #{message}"
            end
        end
    end
end
