class CreateTerritories < ActiveRecord::Migration[6.0]
  def change
    create_table :territories do |t|
      t.integer :distance_from_center, null: false
      t.integer :offset_from_north, null: false

      t.timestamps
    end
  end
end
