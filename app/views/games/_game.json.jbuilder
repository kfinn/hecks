json.(game, :id, :started_at)

current_player = game.players.find_by!(user: current_or_guest_user)

json.status do
    if game.current_turn
        if game.current_turn.player == current_player
            json.actor 'you'
        else
            json.actor game.current_turn.player.name
        end
        json.description  game.current_turn.description
    else
        json.actor 'someone'
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

json.territories game.territories do |territory|
    json.(territory, :id, :x, :y,)
    json.terrain do
        json.id territory.terrain.id
    end

    unless territory.desert?
        json.production_number do
            json.(territory.production_number, :value, :frequency)
        end
    end
end

json.corners game.corners.includes(settlement: :player) do |corner|
    json.(corner, :id, :x, :y)
    if corner.settlement
        json.settlement do
            json.color corner.settlement.color.id
        end
    end
    json.corner_actions current_player.corner_actions[corner]
end

json.borders game.borders.includes(road: :player) do |border|
    json.(border, :id, :x, :y)
    if border.road
        json.road do
            json.color border.road.color.id
        end
    end
    json.border_actions current_player.border_actions[border]
end

json.players game.players.order(:ordering, :created_at).includes(:ordering_roll, :user) do |player|
    json.(player, :id, :ordering)
    json.user do
        json.(player.user, :id, :name)
        json.is_current_user current_player == player
    end
    if player.ordering_roll
        json.ordering_roll do
            json.(player.ordering_roll, :die_1_value, :die_2_value, :value)
        end
    end
    json.color player.color.id
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

json.dice do
    if game.latest_roll
        json.latest_roll do
            json.(game.latest_roll, :die_1_value, :die_2_value, :value)
        end
    end
    json.dice_actions current_player.dice_actions
end
