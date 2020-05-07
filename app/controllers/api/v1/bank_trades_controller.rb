class Api::V1::BankTradesController < Api::ApiController
    def create
        game = Game.find(params[:game_id])
        player = current_or_guest_user.players.find_by!(game: game)
        bank_offer = player.bank_offers.find(params[:bank_offer_id])

        bank_trade = bank_offer.build_bank_trade(create_params)
        if bank_trade.valid?
            bank_trade.save!
            head :created
        else
            render_errors_for bank_trade
        end
    end

    def create_params
        params.require(:bank_trade).permit(:resource_to_receive_id)
    end
end
