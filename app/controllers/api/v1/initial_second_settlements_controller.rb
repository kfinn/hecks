class Api::V1::InitialSecondSettlementsController < Api::ApiController
    def create
        corner = current_or_guest_user.corners.find(params[:corner_id])
        player = current_or_guest_user.players.find_by!(game: corner.game)

        initial_second_settlement = InitialSecondSettlement.new(corner: corner, player: player)
        if initial_second_settlement.valid?
            initial_second_settlement.save!
            head :created
        else
            render_errors_for initial_second_settlement
        end
    end
end
