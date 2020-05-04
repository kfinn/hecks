class InitialSettlement
    include ActiveModel::Model
    attr_accessor :player, :corner

    delegate :game, to: :player

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

    def must_be_players_turn
        errors[:player] << "must be this player's turn" unless game.current_player == player
    end

    def settlement_must_be_valid
        unless settlement.valid?
            settlement.errors.each do |key, message|
                errors[:settlement] << "#{key}: #{message}"
            end
        end
    end
end
