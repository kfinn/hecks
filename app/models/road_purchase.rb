class RoadPurchase
    include ActiveModel::Model
    attr_accessor :player, :border

    delegate :game, to: :player

    validate :player_must_be_able_to_purchase_road
    validate :road_must_be_valid

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            road.save!
            update_player!
        end
    end

    def road
        @road ||= Road.new(player: player, border: border)
    end

    private

    def player_must_be_able_to_purchase_road
        errors[:player] << 'cannot purchase road' unless player.can_purchase_road?
    end

    def road_must_be_valid
        unless road.valid?
            road.errors.each do |key, message|
                errors[:road] << "#{key}: #{message}"
            end
        end
    end

    def update_player!
        player.discard_resource Resource::BRICK
        player.discard_resource Resource::LUMBER
        player.save!
    end
end
