class CreateRoads < ActiveRecord::Migration[6.0]
  def change
    create_table :roads do |t|
      t.belongs_to :player
      t.belongs_to :border, index: { unique: true }

      t.timestamps
    end
  end
end
