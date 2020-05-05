class CreateTurns < ActiveRecord::Migration[6.0]
  def change
    remove_column :players, :initial_settlement_id, :bigint, index: true, foreign_key: { to_table: :settlements }
    remove_column :players, :initial_road_id, :bigint, index: true, foreign_key: { to_table: :roads }
    remove_column :players, :initial_second_settlement_id, :bigint, index: true, foreign_key: { to_table: :settlements }
    remove_column :players, :initial_second_road_id, :bigint, index: true, foreign_key: { to_table: :roads }

    create_table :turns do |t|
      t.string :type, null: false
      t.belongs_to :player, foreign_key: true, null: false
      t.belongs_to :game, foreign_key: true, null: false

      t.belongs_to :settlement, foreign_key: true
      t.belongs_to :road, foreign_key: true

      t.timestamps
    end
  end
end
