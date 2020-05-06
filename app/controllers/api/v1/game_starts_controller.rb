class Api::V1::GameStartsController < Api::ApiController
  def create
    current_or_guest_user.games.find(params[:game_id]).start!
    head :created
  end
end
