class SettlementPurchase
    include ActiveModel::Model
    attr_accessor :player, :corner

    delegate :game, to: :player

    validate :player_must_be_able_to_purchase_settlement
    validate :settlement_must_be_valid

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
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

    def player_must_be_able_to_purchase_settlement
        errors[:player] << 'cannot purchase settlement' unless player.can_purchase_settlement?
    end

    def settlement_must_be_valid
        unless settlement.valid?
            settlement.errors.each do |key, message|
                errors[:settlement] << "#{key}: #{message}"
            end
        end
    end

    def update_player!
        player.discard_resource Resource::BRICK
        player.discard_resource Resource::GRAIN
        player.discard_resource Resource::LUMBER
        player.discard_resource Resource::WOOL
        player.save!
    end
end
