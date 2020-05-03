class AddPlayerOrderingToPlayers < ActiveRecord::Migration[6.0]
  def change
    change_table :players do |t|
      t.references :ordering_roll, foreign_key: { to_table: :rolls }
      t.integer :ordering, index: true
    end
  end
end
