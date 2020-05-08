class Api::V1::DevelopmentCardPurchasesController < Api::ApiController
  def create
    game = current_or_guest_user.games.find(params[:game_id])
    player = current_or_guest_user.players.find_by!(game: game)

    development_card_purchase = DevelopmentCardPurchase.new(player: player)

    if development_card_purchase.valid?
        development_card_purchase.save!
        head :created
    else
        render_errors_for development_card_purchase
    end
  end
end
