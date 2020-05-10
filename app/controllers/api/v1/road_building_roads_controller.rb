class Api::V1::RoadBuildingRoadsController < Api::ApiController
    def create
        border = current_or_guest_user.borders.find(params[:border_id])
        player = current_or_guest_user.players.find_by!(game: border.game)

        road_building_road = RoadBuildingRoad.new(border: border, player: player)
        if road_building_road.valid?
            road_building_road.save!
            head :created
        else
            render_errors_for road_building_road
        end
    end
end
