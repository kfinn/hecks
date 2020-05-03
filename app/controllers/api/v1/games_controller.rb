class Api::V1::GamesController < Api::ApiController
    def show
        @game = Game.find params[:id]
    end
end
