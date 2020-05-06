class Api::V1::SettlementPurchasesController < Api::ApiController
    def create
        corner = current_or_guest_user.corners.find(params[:corner_id])
        player = current_or_guest_user.players.find_by!(game: corner.game)

        settlement_purchase = SettlementPurchase.new(corner: corner, player: player)
        if settlement_purchase.valid?
            settlement_purchase.save!
            head :created
        else
            render_errors_for settlement_purchase
        end
    end
end
