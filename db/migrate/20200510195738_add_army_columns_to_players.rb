class AddArmyColumnsToPlayers < ActiveRecord::Migration[6.0]
  def change
    change_table :players do |t|
      t.integer :army_size, null: false, default: 0
      t.datetime :army_since, default: -> { 'NOW()' }
    end
  end
end
