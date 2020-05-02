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

json.players game.game_memberships do |game_membership|
    json.(game_membership.user, :id, :name)
end
