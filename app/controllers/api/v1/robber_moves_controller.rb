class Api::V1::RobberMovesController < Api::ApiController
    def create
        territory = current_or_guest_user.territories.find(params[:territory_id])
        player = current_or_guest_user.players.find_by!(game: territory.game)

        robber_move = RobberMove.new(territory: territory, player: player)
        if robber_move.valid?
            robber_move.save!
            head :created
        else
            render_errors_for robber_move
        end
    end
end
