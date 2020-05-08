class CreatePlayerOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :player_offers do |t|
      t.references :turn, foreign_key: true, null: false

      t.integer :brick_cards_count_from_offering_player, null: false
      t.integer :grain_cards_count_from_offering_player, null: false
      t.integer :lumber_cards_count_from_offering_player, null: false
      t.integer :ore_cards_count_from_offering_player, null: false
      t.integer :wool_cards_count_from_offering_player, null: false

      t.integer :brick_cards_count_from_agreeing_player, null: false
      t.integer :grain_cards_count_from_agreeing_player, null: false
      t.integer :lumber_cards_count_from_agreeing_player, null: false
      t.integer :ore_cards_count_from_agreeing_player, null: false
      t.integer :wool_cards_count_from_agreeing_player, null: false

      t.timestamps
    end
  end
end
