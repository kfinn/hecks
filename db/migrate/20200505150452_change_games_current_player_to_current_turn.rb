class ChangeGamesCurrentPlayerToCurrentTurn < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :current_player_id, :bigint, index: true, foreign_key: { to_table: :players }

    change_table :games do |t|
      t.references :current_turn, foreign_key: { to_table: :turns }
    end
  end
end
