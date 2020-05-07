class AddRobberMovedAtToRepeatingTurns < ActiveRecord::Migration[6.0]
  def change
    add_column :turns, :robber_moved_at, :datetime
    add_reference :turns, :robber_moved_to_territory, foreign_key: { to_table: :territories }
  end
end
