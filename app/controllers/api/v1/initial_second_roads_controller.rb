class Api::V1::InitialSecondRoadsController < Api::ApiController
    def create
        border = current_or_guest_user.borders.find(params[:border_id])
        player = current_or_guest_user.players.find_by!(game: border.game)

        initial_second_road = InitialSecondRoad.new(border: border, player: player)
        if initial_second_road.valid?
            initial_second_road.save!
            head :created
        else
            render_errors_for initial_second_road
        end
    end
end
