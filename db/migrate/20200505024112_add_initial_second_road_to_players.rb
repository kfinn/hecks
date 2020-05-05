class AddInitialSecondRoadToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_reference :players, :initial_second_road, foreign_key: { to_table: :roads }
  end
end
