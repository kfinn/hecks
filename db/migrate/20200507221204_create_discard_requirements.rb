class CreateDiscardRequirements < ActiveRecord::Migration[6.0]
  def change
    create_table :discard_requirements do |t|
      t.references :player, foreign_key: true, null: false
      t.references :turn, foreign_key: true, null: false
      t.integer :resource_cards_count, null: false
      t.datetime :completed_at, index: true

      t.timestamps
    end
  end
end
