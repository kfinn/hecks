class GamesChannel < ApplicationCable::Channel
    def subscribed
        stream_for Game.find(params[:id])
    end
end
