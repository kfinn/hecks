class Api::V1::PlayerTradesController < Api::ApiController
    def create
        player_offer_response = current_or_guest_user.player_offer_responses.agreeing.find(params[:player_offer_response_id])
        player = current_or_guest_user.players.find_by!(game: player_offer_response.game)

        player_trade = PlayerTrade.new(player_offer_response: player_offer_response)
        if player_trade.valid?
            player_trade.save!
            head :created
        else
            render_errors_for player_trade
        end
    end
end
