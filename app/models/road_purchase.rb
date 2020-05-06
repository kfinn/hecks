class RoadPurchase
    include ActiveModel::Model
    attr_accessor :player, :border

    delegate :game, to: :player

    validate :player_must_be_able_to_purchase_road
    validate :road_must_be_valid

    def save!
        raise ActiveRecord::RecordInvalid(self) unless valid?
        ApplicationRecord.transaction do
            road.save!
            update_player!
        end
    end

    def road
        unless instance_variable_defined?(:@road)
            @road = Road.new(
                player: player,
                border: border
            )
        end
        @road
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
        player.update!(
            brick_cards_count: player.brick_cards_count - 1,
            lumber_cards_count: player.lumber_cards_count - 1
        )
    end
end
