class InitialSecondRoad
    include ActiveModel::Model
    attr_accessor :player, :border

    delegate :game, to: :player

    validate :player_must_be_able_to_create_initial_second_road
    validate :road_must_be_valid
    validate :road_must_connect_to_initial_second_settlement

    def self.border_action_for_player(**kwargs)
        if new(**kwargs).valid?
            return "#{name}#create"
        end
    end

    def save
        valid? && road.save && player.save
    end

    def road
        unless instance_variable_defined?(:@road)
            @road = Road.new(
                player: player,
                border: border
            )
            player.initial_second_road = @road
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
end
