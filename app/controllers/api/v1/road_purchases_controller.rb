class Api::V1::RoadPurchasesController < Api::ApiController
    def create
        border = current_or_guest_user.borders.find(params[:border_id])
        player = current_or_guest_user.players.find_by!(game: border.game)

        road_purchase = RoadPurchase.new(border: border, player: player)
        if road_purchase.valid?
            road_purchase.save!
            head :created
        else
            render_errors_for road_purchase
        end
    end
end
