class Api::V1::ProductionRollsController < Api::ApiController
  def create
    game = current_or_guest_user.games.find(params[:game_id])
    player = current_or_guest_user.players.find_by!(game: game)

    production_roll = ProductionRoll.new(player: player)

    if production_roll.valid?
        production_roll.save!
        head :created
    else
        render_errors_for production_roll
    end
  end
end
