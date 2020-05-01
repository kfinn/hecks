class AddTerrainToTerritories < ActiveRecord::Migration[6.0]
  def up
    execute <<~SQL
      CREATE TYPE territory_terrain_id_type
      AS ENUM ('desert', 'fields', 'pasture', 'forest', 'mountains', 'hills')
    SQL

    execute <<~SQL
      TRUNCATE TABLE territories CASCADE;
    SQL

    change_table :territories do |t|
      t.column :terrain_id, :territory_terrain_id_type, null: false, index: true
    end
  end

  def down
    remove_column :territories, :terrain_id

    execute <<~SQL
      DROP TYPE territory_terrain_id_type
    SQL
  end
end
