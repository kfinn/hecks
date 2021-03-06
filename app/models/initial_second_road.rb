class InitialSecondRoad
    include ActiveModel::Model
    attr_accessor :player, :border

    delegate :game, to: :player

    validate :player_must_be_able_to_create_initial_second_road
    validate :road_must_be_valid
    validate :road_must_connect_to_initial_second_settlement

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            road.save!
            update_player!
            update_game!
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

    def player_must_be_able_to_create_initial_second_road
        errors[:player] << 'cannot create initial second road' unless player.can_create_initial_second_road?
    end

    def road_must_be_valid
        unless road.valid?
            road.errors.each do |key, message|
                errors[:road] << "#{key}: #{message}"
            end
        end
    end

    def road_must_connect_to_initial_second_settlement
        if player.initial_second_settlement && border.corners.include?(player.initial_second_settlement.corner)
            return
        end
        errors[:border] << 'must connect to initial second settlement'
    end

    def update_player!
        player.update! initial_second_road: road
    end

    def update_game!
        game.end_turn!
    end
end
