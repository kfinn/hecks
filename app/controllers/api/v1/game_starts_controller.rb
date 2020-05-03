class Api::V1::GameStartsController < Api::ApiController
  def create
    @user = current_or_guest_user
    @game = @user.games.find(params[:game_id])
    @game.start!
    head :created
  end
end
