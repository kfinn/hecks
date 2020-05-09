class Api::V1::CurrentPlayersController < Api::ApiController
    def update
        game = current_or_guest_user.games.find(params[:game_id])
        player = current_or_guest_user.players.find_by!(game: game)
        if player.update update_params
            head :ok
        else
            render_errors_for player
        end
    end

    def update_params
        params.require(:current_player).permit(:name, :color_id)
    end
end
