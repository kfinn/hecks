class InitialRoad
    include ActiveModel::Model
    attr_accessor :player, :border

    delegate :game, to: :player

    # validate :must_be_players_turn
    validate :road_must_be_valid
    validate :road_must_connect_to_initial_settlement

    def save
        valid? && road.save && player.save
    end

    def road
        unless instance_variable_defined?(:@road)
            @road = Road.new(
                player: player,
                border: border
            )
            player.initial_road = @road
        end
        @road
    end

    private

    # def must_be_players_turn
    #     errors[:player] << "must be this player's turn" unless game.current_player == player
    # end

    def road_must_be_valid
        unless road.valid?
            road.errors.each do |key, message|
                errors[:road] << "#{key}: #{message}"
            end
        end
    end

    def road_must_connect_to_initial_settlement
        if border.corners.include? player.initial_settlement.corner
            return
        end
        errors[:border] << 'must connect to initial settlement'
    end
end
