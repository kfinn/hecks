class GamePreviewsController < ApplicationController
    def show
        @game = Game.find_by key: params[:game_id]
        if current_or_guest_user.games.include? @game
            redirect_to game_path(id: @game.key)
        end
    end
end
