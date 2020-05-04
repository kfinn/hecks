class AddInitialSettlementToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_reference :players, :initial_settlement, foreign_key: { to_table: :settlements }
  end
end
