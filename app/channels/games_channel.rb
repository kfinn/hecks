class GamesChannel < ApplicationCable::Channel
    def subscribed
        game = Game.find(params[:id])
        stream_for game
    end
end
