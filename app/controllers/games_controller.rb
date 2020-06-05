class GamesController < ApplicationController
    def create
        @game = current_or_guest_user.games.create! create_params
        redirect_to game_path(@game.key)
    end

    def show
        @game = current_or_guest_user.games.find_by key: params[:id]
        if @game.blank?
            redirect_to game_game_preview_path(game_id: params[:id])
        end
    end

    def create_params
        params.require(:game).permit(:board_config_id)
    end
end
