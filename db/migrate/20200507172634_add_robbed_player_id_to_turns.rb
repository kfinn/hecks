class AddRobbedPlayerIdToTurns < ActiveRecord::Migration[6.0]
  def change
    add_reference :turns, :robbed_player, foreign_key: { to_table: :players }
  end
end
