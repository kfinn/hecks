class AddNameToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :name, :string

    execute <<~SQL
      UPDATE players SET name = (SELECT name FROM users WHERE users.id = players.user_id);
    SQL
  end
end
