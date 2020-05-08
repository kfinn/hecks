class Api::V1::PlayerOfferAgreementsController < Api::ApiController
    def create
        player_offer = current_or_guest_user.player_offers.find(params[:player_offer_id])
        player = current_or_guest_user.players.find_by!(game: player_offer.game)

        player_offer_agreement = player_offer.player_offer_agreements.build(player: player)
        if player_offer_agreement.valid?
            player_offer_agreement.save!
            head :created
        else
            render_errors_for player_offer_agreement
        end
    end
end
