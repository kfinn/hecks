class RoadBuildingRoad
    include ActiveModel::Model
    attr_accessor :player, :border

    validate :player_must_have_incomplete_road_building_card_play
    validate :road_must_be_valid

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            road.save!
            update_road_building_card_play!
        end
    end

    def road
        @road ||= Road.new(player: player, border: border)
    end

    def road_building_card_play
        @road_building_card_play ||= player.incomplete_road_building_card_plays.first
    end

    private

    def player_must_have_incomplete_road_building_card_play
        errors[:player] << 'cannot build road' unless player.any_incomplete_road_building_card_plays?
    end

    def road_must_be_valid
        unless road.valid?
            road.errors.each do |key, message|
                errors[:road] << "#{key}: #{message}"
            end
        end
    end

    def update_road_building_card_play!
        road_building_card_play.next_road = road
        road_building_card_play.save!
    end
end
