class AddUpgradedToCityAtToSettlements < ActiveRecord::Migration[6.0]
  def change
    add_column :settlements, :upgraded_to_city_at, :datetime
  end
end
