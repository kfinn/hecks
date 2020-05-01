class CreateAdjacencies < ActiveRecord::Migration[6.0]
  def change
    execute <<~SQL
      CREATE TYPE adjacency_corner_territory_relationship
      AS ENUM ('north', 'northeast', 'southeast', 'south', 'southwest', 'northwest');
    SQL

    execute <<~SQL
      CREATE TYPE adjacency_border_territory_relationship
      AS ENUM ('northeast', 'east', 'southeast', 'southwest', 'west', 'northwest');
    SQL

    create_table :adjacencies do |t|
      t.belongs_to :game, foreign_key: true
      t.belongs_to :corner, foreign_key: true
      t.belongs_to :border, foreign_key: true
      t.belongs_to :territory, foreign_key: true

      t.column(:corner_territory_relationship, :adjacency_corner_territory_relationship, null: false)
      t.column(:border_territory_relationship, :adjacency_border_territory_relationship, null: false)

      t.timestamps
    end

    add_index(
      :adjacencies,
      [:territory_id, :corner_territory_relationship, :border_territory_relationship],
      name: :index_adjacencies_uniquely_on_physical_limits,
      unique: true
    )
  end
end
