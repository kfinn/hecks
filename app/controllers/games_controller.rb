class GamesController < ApplicationController
    def create
        @user = current_or_guest_user
        @game = @user.games.create!

        redirect_to game_path(@game.key)
    end

    def show
        @user = current_or_guest_user
        @game = Game.find_by! key: params[:id]
        unless current_or_guest_user.in? @game.users
            @game.game_memberships.create! user: @user
        end
    end
end
