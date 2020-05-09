class CreateRobberMoveRequirements < ActiveRecord::Migration[6.0]
  def change
    create_table :robber_move_requirements do |t|
      t.references :turn, foreign_key: true, null: false
      t.references :moved_to_territory, foreign_key: { to_table: :territories }
      t.references :robbed_player, foreign_key: { to_table: :players }
      t.boolean :has_robbable_players, null: false, default: false

      t.timestamps
    end

    remove_reference :turns, :robber_moved_to_territory, foreign_key: { to_table: :territories }
    remove_reference :turns, :robbed_player, foreign_key: { to_table: :players }
    remove_column :turns, :robber_moved_at, :datetime
  end
end
