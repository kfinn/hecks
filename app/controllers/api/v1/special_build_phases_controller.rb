class Api::V1::SpecialBuildPhasesController < Api::ApiController
  def create
    game = current_or_guest_user.games.find(params[:game_id])
    player = current_or_guest_user.players.find_by!(game: game)

    special_build_phase = player.special_build_phases.build(turn: game.current_turn)

    if special_build_phase.valid?
        special_build_phase.save!
        head :created
    else
        render_errors_for special_build_phase
    end
  end
end
