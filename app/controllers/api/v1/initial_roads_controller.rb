class Api::V1::InitialRoadsController < Api::ApiController
    def create
        border = current_or_guest_user.borders.find(params[:border_id])
        player = current_or_guest_user.players.find_by!(game: border.game)

        initial_road = InitialRoad.new(border: border, player: player)
        if initial_road.valid?
            initial_road.save!
            head :created
        else
            render_errors_for initial_road
        end
    end
end
