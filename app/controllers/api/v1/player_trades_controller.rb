class Api::V1::PlayerTradesController < Api::ApiController
    def create
        player_offer_agreement = current_or_guest_user.player_offer_agreements.find(params[:player_offer_agreement_id])
        player = current_or_guest_user.players.find_by!(game: player_offer_agreement.game)

        player_trade = PlayerTrade.new(player_offer_agreement: player_offer_agreement)
        if player_trade.valid?
            player_trade.save!
            head :created
        else
            render_errors_for player_trade
        end
    end
end
