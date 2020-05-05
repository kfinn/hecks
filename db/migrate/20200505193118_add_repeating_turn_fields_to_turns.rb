class AddRepeatingTurnFieldsToTurns < ActiveRecord::Migration[6.0]
  def change
    change_table :turns do |t|
      t.references :roll, foreign_key: true
      t.datetime :ended_at
    end
  end
end
