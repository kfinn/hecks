class CreatePlayerOfferAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :player_offer_agreements do |t|
      t.references :player_offer, foreign_key: true, null: false
      t.references :player, foreign_key: true, null: false

      t.timestamps
    end
    add_index :player_offer_agreements, [:player_offer_id, :player_id], unique: true
  end
end
