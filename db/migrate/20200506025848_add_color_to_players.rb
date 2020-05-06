class AddColorToPlayers < ActiveRecord::Migration[6.0]
  def up
    add_column :players, :color_id, :string
    execute <<~SQL
      UPDATE players SET color_id = 'blue' WHERE ordering = 0;
      UPDATE players SET color_id = 'white' WHERE ordering = 1;
      UPDATE players SET color_id = 'red' WHERE ordering = 2;
      UPDATE players SET color_id = 'orange' WHERE ordering = 3;
    SQL
    change_column :players, :color_id, :string, null: :false
    add_index :players, [:color_id, :game_id], unique: true
  end

  def down
    remove_index :players, [:color_id, :game_id], unique: true
    remove_column :players, :color_id
  end
end
