class CreateHarbors < ActiveRecord::Migration[6.0]
  def change
    create_table :harbors do |t|
      t.references :game, foreign_key: true, null: false
      t.integer :x, null: false
      t.integer :y, null: false
      t.string :harbor_offer_id, null: false, index: true

      t.timestamps
    end
  end
end
