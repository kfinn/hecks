class AddInitialRoadToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_reference :players, :initial_road, foreign_key: { to_table: :roads }
  end
end
