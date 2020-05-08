class CreateDevelopmentCards < ActiveRecord::Migration[6.0]
  def change
    create_table :development_cards do |t|
      t.string :development_card_behavior_id, null: false, index: true
      t.integer :ordering, null: false

      t.references :game, foreign_key: true, null: false
      t.references :player, foreign_key: true
      t.references :purchased_during_turn, foreign_key: { to_table: :turns }
      t.references :played_during_turn, foreign_key: { to_table: :turns }

      t.timestamps
    end
  end
end
