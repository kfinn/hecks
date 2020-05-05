class InitialRoad
    include ActiveModel::Model
    attr_accessor :player, :border

    delegate :game, to: :player

    validate :must_be_players_turn
    validate :player_must_have_initial_settlement
    validate :player_must_not_have_initial_road
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

    def must_be_players_turn
        earlier_players_without_initial_setup = player.earlier_players.without_initial_setup
        errors[:player] << "must be this player's turn" if earlier_players_without_initial_setup.any?
    end

    def player_must_have_initial_settlement
        errors[:player] << 'must have an initial settlement' if player.initial_settlement.blank?
    end

    def player_must_not_have_initial_road
        errors[:player] << 'must not already have an initial road' if player.initial_road.present?
    end

    def road_must_be_valid
        unless road.valid?
            road.errors.each do |key, message|
                errors[:road] << "#{key}: #{message}"
            end
        end
    end

    def road_must_connect_to_initial_settlement
        if player.initial_settlement && border.corners.include?(player.initial_settlement.corner)
            return
        end
        errors[:border] << 'must connect to initial settlement'
    end
end
