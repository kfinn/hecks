class GamesController < ApplicationController
    def create
        @user = current_or_guest_user
        @game = @user.games.create!

        redirect_to @game
    end

    def show
        @game = current_or_guest_user.games.find(params[:id])
    end
end
