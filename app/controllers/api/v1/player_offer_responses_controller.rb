class Api::V1::PlayerOfferResponsesController < Api::ApiController
    def create
        player_offer = current_or_guest_user.player_offers.find(params[:player_offer_id])
        player = current_or_guest_user.players.find_by!(game: player_offer.game)

        player_offer_response = player_offer.player_offer_responses.build({ player: player }.merge(create_params))
        if player_offer_response.valid?
            player_offer_response.save!
            head :created
        else
            render_errors_for player_offer_response
        end
    end

    def create_params
        params.require(:player_offer_response).permit(:agreeing)
    end
end
