class Api::V1::PlayerOffersController < Api::ApiController
  def create
    game = current_or_guest_user.games.find(params[:game_id])
    player = current_or_guest_user.players.find_by!(game: game)
    player_offer = PlayerOffer.new({ turn: player.current_repeating_turn }.merge(create_params))

    if player_offer.valid?
      player_offer.save!
      head :created
    else
      render_errors_for player_offer
    end
  end

  def create_params
    params.require(:player_offer).permit(
      :brick_cards_count_from_offering_player,
      :grain_cards_count_from_offering_player,
      :lumber_cards_count_from_offering_player,
      :ore_cards_count_from_offering_player,
      :wool_cards_count_from_offering_player,

      :brick_cards_count_from_agreeing_player,
      :grain_cards_count_from_agreeing_player,
      :lumber_cards_count_from_agreeing_player,
      :ore_cards_count_from_agreeing_player,
      :wool_cards_count_from_agreeing_player
    )
  end
end
