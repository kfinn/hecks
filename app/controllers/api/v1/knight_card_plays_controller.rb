class Api::V1::KnightCardPlaysController < Api::ApiController
    def create
        development_card = current_or_guest_user.development_cards.find(params[:development_card_id])
        player = current_or_guest_user.players.find_by!(game: development_card.game)

        knight_card_play = KnightCardPlay.new(development_card: development_card)
        if knight_card_play.valid?
            knight_card_play.save!
            head :created
        else
            render_errors_for knight_card_play
        end
    end
end
