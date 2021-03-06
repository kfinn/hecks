json.(game, :id, :started_at)
json.allows_special_build_phase game.allows_special_build_phase?

current_player = game.players.find_by!(user: current_or_guest_user)

json.status do
    if game.current_turn
        if game.current_turn.player == current_player
            json.actor 'you'
            json.actor_is_current_player true
        else
            json.actor game.current_turn.player.name
            json.actor_is_current_player false
        end
        json.description  game.current_turn.description
    elsif game.winner
        json.winner game.winner.name
        json.winner_is_current_player game.winner == current_player
        json.winner_settlement_score game.game_scoring.winner_settlement_score
        json.winner_largest_army_score game.game_scoring.winner_largest_army_score
        json.winner_longest_road_score game.game_scoring.winner_longest_road_score
        json.winner_victory_point_card_score game.game_scoring.winner_victory_point_card_score
    else
        json.actor 'someone'
        json.actor_is_current_player true
        json.description 'start the game'
    end
end

json.bank_offers current_player.bank_offers do |bank_offer|
    json.resource_to_give do
        json.id bank_offer.resource_to_give.id
    end
    json.(bank_offer, :resource_to_give_count_required)
    json.bank_offer_actions current_player.bank_offer_actions[bank_offer]
end

json.player_offers game.player_offers.includes(:player).includes(player_offer_responses: :player) do |player_offer|
    json.(
        player_offer,
        :id,
        :player_name,
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

    json.player_offer_responses player_offer.player_offer_responses do |player_offer_response|
        json.(player_offer_response, :id, :player_name, :agreeing)

        json.player_offer_response_actions current_player.player_offer_response_actions[player_offer_response]
    end

    json.player_offer_actions current_player.player_offer_actions[player_offer]
end

json.(current_player, :new_player_offer_actions)

if current_player.pending_discard_requirement
    json.pending_discard_requirement do
        json.(current_player.pending_discard_requirement, :id, :resource_cards_count)
        json.pending_discard_requirement_actions current_player.pending_discard_requirement_actions
    end
end

json.territories game.territories.includes(:game) do |territory|
    json.(territory, :id, :x, :y)
    json.terrain do
        json.id territory.terrain.id
    end

    unless territory.desert?
        json.production_number do
            json.(territory.production_number, :value, :frequency)
        end
    end

    json.has_robber territory.has_robber?

    json.territory_actions current_player.territory_actions[territory]
end

json.corners game.corners.includes(settlement: :player) do |corner|
    json.(corner, :id, :x, :y)
    if corner.settlement
        json.settlement do
            json.color corner.settlement.color.id
            json.is_city corner.settlement.city?
        end
    end
    json.corner_actions current_player.corner_actions[corner]
end

json.borders game.borders.includes(road: [:player], corners: []) do |border|
    json.(border, :id, :x, :y)
    if border.road
        json.road do
            json.color border.road.color.id
        end
    end
    json.corners border.corners do |corner|
        json.(corner, :x, :y)
    end
    json.border_actions current_player.border_actions[border]
end

json.harbors game.harbors.includes(:corners) do |harbor|
    json.(harbor, :id, :x, :y)
    json.harbor_offer do
        json.call(harbor.harbor_offer, :exchange_rate)
        if harbor.harbor_offer.resource_to_give.present?
            json.resource_to_give do
                json.call(harbor.harbor_offer.resource_to_give, :id)
            end
        end
    end
    json.corners harbor.corners do |corner|
        json.(corner, :x, :y)
    end
end

json.players game.players.order(:ordering, :created_at).includes(:ordering_roll, :user) do |player|
    json.(
        player,
        :id,
        :ordering,
        :total_resource_cards_count,
        :name,
        :active_development_cards_count,
        :army_size,
        :longest_road_traversal_length
    )

    json.user do
        json.is_current_user current_player == player
    end
    if player.ordering_roll
        json.ordering_roll do
            json.(player.ordering_roll, :die_1_value, :die_2_value, :value)
        end
    end
    json.color player.color.id

    json.score game.game_scoring.scores_by_player[player]
    json.player_actions current_player.player_actions[player]
end

json.hand do
    json.(
        current_player,
        :brick_cards_count,
        :grain_cards_count,
        :lumber_cards_count,
        :ore_cards_count,
        :wool_cards_count
    )
end

json.development_cards current_player.active_development_cards do |development_card|
    json.(development_card, :id, :name)
    json.development_card_behavior do
        json.(development_card.development_card_behavior, :id, :description)
    end

    json.development_card_actions current_player.development_card_actions[development_card]
end

json.(current_player, :new_development_card_actions, :turn_actions, :special_build_phase_actions)

json.dice do
    if game.latest_roll
        json.latest_roll do
            json.(game.latest_roll, :die_1_value, :die_2_value, :value)
        end
    end
    json.dice_actions current_player.dice_actions
end
