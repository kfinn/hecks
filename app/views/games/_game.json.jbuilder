json.(game, :id, :started_at)

json.territories game.territories do |territory|
    json.(territory, :id, :x, :y,)
    json.terrain do
        json.(territory.terrain, :id, :name)
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
            json.player do
                json.id corner.settlement.player.id
            end
        end
    end
end

json.borders game.borders.includes(road: :player) do |border|
    json.(border, :id, :x, :y)
    if border.road
        json.road do
            json.player do
                json.id border.road.player.id
            end
        end
    end
end

json.players game.players.order(:ordering, :created_at).includes(:ordering_roll, :user) do |player|
    json.(player, :id, :ordering)
    json.user do
        json.(player.user, :id, :name)
    end
    if player.ordering_roll
        json.ordering_roll do
            json.(player.ordering_roll, :die_1_value, :die_2_value, :value)
        end
    end
end
