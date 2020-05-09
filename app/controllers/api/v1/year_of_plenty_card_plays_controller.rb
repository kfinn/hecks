class Api::V1::YearOfPlentyCardPlaysController < Api::ApiController
    def create
        development_card = current_or_guest_user.development_cards.find(params[:development_card_id])
        player = current_or_guest_user.players.find_by!(game: development_card.game)

        year_of_plenty_card_play = YearOfPlentyCardPlay.new({ development_card: development_card }.merge(create_params))
        if year_of_plenty_card_play.valid?
            year_of_plenty_card_play.save!
            head :created
        else
            render_errors_for year_of_plenty_card_play
        end
    end

    def create_params
        params.require(:year_of_plenty_card_play).permit(:resource_1_id, :resource_2_id)
    end
end
