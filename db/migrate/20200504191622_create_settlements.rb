class CreateSettlements < ActiveRecord::Migration[6.0]
  def change
    create_table :settlements do |t|
      t.belongs_to :player
      t.belongs_to :corner, index: { unique: true }

      t.timestamps
    end
  end
end
