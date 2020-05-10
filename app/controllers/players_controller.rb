class PlayersController < ApplicationController
    def create
        game = Game.find_by! key: params[:game_id]
        player = current_or_guest_user.players.build(game: game)
        if player.save
            redirect_to game_path(id: game.key)
        else
            redirect_to game_game_preview_path(game_id: game.key)
        end
    end
end
