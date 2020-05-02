class GamesController < ApplicationController
    def create
        @user = current_or_guest_user
        @game = @user.games.create!

        redirect_to game_path(@game.key)
    end

    def show
        @game = current_or_guest_user.games.find_by!(key: params[:id])
    end
end
