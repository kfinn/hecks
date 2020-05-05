class InitialSettlement
    include ActiveModel::Model
    attr_accessor :player, :corner

    delegate :game, to: :player

    validate :player_must_be_able_to_create_initial_settlement
    validate :settlement_must_be_valid

    def save!
        raise ActiveRecord::RecordInvalid(self) unless valid?
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

    def player_must_be_able_to_create_initial_settlement
        errors[:player] << 'cannot create initial settlement' unless player.can_create_initial_settlement?
    end

    def settlement_must_be_valid
        unless settlement.valid?
            settlement.errors.each do |key, message|
                errors[:settlement] << "#{key}: #{message}"
            end
        end
    end

    def update_player!
        player.update! initial_settlement: settlement
    end
end
