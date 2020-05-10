class ChangePlayerOfferAgremeentsToPlayerOfferResponses < ActiveRecord::Migration[6.0]
  def change
    rename_table :player_offer_agreements, :player_offer_responses

    add_column :player_offer_responses, :agreeing, :boolean, null: false, default: true
  end
end
