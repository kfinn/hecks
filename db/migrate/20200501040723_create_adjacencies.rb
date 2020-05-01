class CreateAdjacencies < ActiveRecord::Migration[6.0]
  def change
    create_table :adjacencies do |t|
      t.belongs_to :game, foreign_key: true
      t.belongs_to :corner, foreign_key: true
      t.belongs_to :border, foreign_key: true
      t.belongs_to :territory, foreign_key: true

      t.timestamps
    end
  end
end
