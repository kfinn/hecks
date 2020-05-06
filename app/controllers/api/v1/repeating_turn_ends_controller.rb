class Api::V1::RepeatingTurnEndsController < Api::ApiController
  def create
    game = current_or_guest_user.games.find(params[:game_id])
    player = current_or_guest_user.players.find_by!(game: game)

    repeating_turn_end = RepeatingTurnEnd.new(player: player)

    if repeating_turn_end.valid?
        repeating_turn_end.save!
        head :created
    else
        render_errors_for repeating_turn_end
    end
  end
end
