class CreateBorders < ActiveRecord::Migration[6.0]
  def change
    create_table :borders do |t|
      t.integer :x, null: false
      t.integer :y, null: false

      t.timestamps
    end
  end
end
