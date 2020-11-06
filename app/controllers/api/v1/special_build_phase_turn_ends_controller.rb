class Api::V1::SpecialBuildPhaseTurnEndsController < Api::ApiController
  def create
    game = current_or_guest_user.games.find(params[:game_id])
    player = current_or_guest_user.players.find_by!(game: game)

    special_build_phase_turn_end = SpecialBuildPhaseTurnEnd.new(player: player)

    if special_build_phase_turn_end.valid?
        special_build_phase_turn_end.save!
        head :created
    else
        render_errors_for special_build_phase_turn_end
    end
  end
end
