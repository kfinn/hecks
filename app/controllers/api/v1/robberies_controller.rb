class Api::V1::RobberiesController < Api::ApiController
    def create
        player_to_rob = current_or_guest_user.opponent_players.find(params[:player_id])
        robbing_player = current_or_guest_user.players.find_by! game: player_to_rob.game

        robbery = Robbery.new(
            robbing_player: robbing_player,
            player_to_rob: player_to_rob
        )
        if robbery.valid?
            robbery.save!
            head :created
        else
            render_errors_for robbery
        end
    end
end
