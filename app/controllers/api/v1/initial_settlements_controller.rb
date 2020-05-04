class Api::V1::InitialSettlementsController < Api::ApiController
    def create
        corner = current_or_guest_user.corners.find(params[:corner_id])
        player = current_or_guest_user.players.find_by!(game: corner.game)

        initial_settlement = InitialSettlement.new(corner: corner, player: player)
        if initial_settlement.save
            head :created
        else
            render status: :unprocessable_entity, partial: 'errors/errors', locals: { errors: initial_settlement.errors }
        end
    end
end
