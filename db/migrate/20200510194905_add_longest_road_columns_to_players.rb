class AddLongestRoadColumnsToPlayers < ActiveRecord::Migration[6.0]
  def change
    change_table :players do |t|
      t.integer :longest_road_traversal_length, null: false, default: 0
      t.datetime :longest_road_traversal_since, null: false, default: -> { 'NOW()' }
    end
  end
end
