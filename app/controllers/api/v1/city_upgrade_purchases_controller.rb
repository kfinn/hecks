class Api::V1::CityUpgradePurchasesController < Api::ApiController
    def create
        corner = current_or_guest_user.corners.find(params[:corner_id])
        player = current_or_guest_user.players.find_by!(game: corner.game)

        city_upgrade_purchase = CityUpgradePurchase.new(corner: corner, player: player)
        if city_upgrade_purchase.valid?
            city_upgrade_purchase.save!
            head :created
        else
            render_errors_for city_upgrade_purchase
        end
    end
end
