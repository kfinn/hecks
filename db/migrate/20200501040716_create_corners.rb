class CreateCorners < ActiveRecord::Migration[6.0]
  def change
    create_table :corners do |t|
      t.integer :x, null: false
      t.integer :y, null: false

      t.timestamps
    end
  end
end
