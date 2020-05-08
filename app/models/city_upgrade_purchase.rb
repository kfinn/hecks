class CityUpgradePurchase
    include ActiveModel::Model
    attr_accessor :player, :corner

    delegate :game, to: :player
    delegate :settlement, to: :corner

    validates :settlement, presence: true
    validate :player_must_be_able_to_purchase_city_upgrade
    validate :settlement_must_not_be_upgraded_to_city

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            settlement.upgrade_to_city!
            update_player!
        end
    end

    private

    def player_must_be_able_to_purchase_city_upgrade
        errors[:player] << 'cannot purchase settlement' unless player.can_purchase_city_upgrade?
    end

    def settlement_must_not_be_upgraded_to_city
        errors[:corner] << 'already has upgraded settlement' if settlement&.city?
    end

    def update_player!
        player.discard_resource Resource::GRAIN, 2
        player.discard_resource Resource::ORE, 3
        player.save!
    end
end
