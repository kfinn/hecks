class GamesController < ApplicationController
    def create
        @user = current_or_guest_user
        @game = @user.games.create!

        redirect_to game_path(@game.key)
    end

    def show
        @user = current_or_guest_user
        @game = Game.find_by! key: params[:id]
        if @game.joinable? && !@game.users.include?(@user)
            @game.players.create! user: @user
        end
    end
end
