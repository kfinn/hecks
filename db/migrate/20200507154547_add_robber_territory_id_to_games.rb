class AddRobberTerritoryIdToGames < ActiveRecord::Migration[6.0]
  def change
    add_reference :games, :robber_territory, foreign_key: { to_table: :territories }
    execute <<~SQL
      UPDATE games SET robber_territory_id = (
        SELECT territories.id
        FROM territories
        JOIN adjacencies ON adjacencies.territory_id = territories.id
        WHERE adjacencies.game_id = games.id
        AND territories.terrain_id = 'desert'
        LIMIT 1
      );
    SQL
    change_column_null :games, :robber_territory_id, false
  end
end
