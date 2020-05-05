class AddResourceCardCountsToPlayers < ActiveRecord::Migration[6.0]
  def change
    change_table :players do |t|
      t.integer :brick_cards_count, null: false, default: 0
      t.integer :grain_cards_count, null: false, default: 0
      t.integer :lumber_cards_count, null: false, default: 0
      t.integer :ore_cards_count, null: false, default: 0
      t.integer :wool_cards_count, null: false, default: 0
    end
  end
end
