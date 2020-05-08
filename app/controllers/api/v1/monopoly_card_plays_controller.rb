class Api::V1::MonopolyCardPlaysController < Api::ApiController
    def create
        development_card = current_or_guest_user.development_cards.find(params[:development_card_id])
        player = current_or_guest_user.players.find_by!(game: development_card.game)

        monopoly_card_play = MonopolyCardPlay.new({ development_card: development_card }.merge(create_params))
        if monopoly_card_play.valid?
            monopoly_card_play.save!
            head :created
        else
            render_errors_for monopoly_card_play
        end
    end

    def create_params
        params.require(:monopoly_card_play).permit(:resource_id)
    end
end
