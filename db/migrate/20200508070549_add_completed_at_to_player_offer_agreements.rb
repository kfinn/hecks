class AddCompletedAtToPlayerOfferAgreements < ActiveRecord::Migration[6.0]
  def change
    add_column :player_offer_agreements, :completed_at, :datetime, index: true
  end
end
