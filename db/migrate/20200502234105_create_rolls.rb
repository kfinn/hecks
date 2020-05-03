class CreateRolls < ActiveRecord::Migration[6.0]
  def change
    create_table :rolls do |t|
      t.integer :die_1_value
      t.integer :die_2_value

      t.timestamps
    end
  end
end
