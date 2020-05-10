class CreateCornerHarbors < ActiveRecord::Migration[6.0]
  def change
    create_table :corner_harbors do |t|
      t.references :corner, foreign_key: true, index: { unique: true }
      t.references :harbor, foreign_key: true

      t.timestamps
    end

    add_index :corner_harbors, [:corner_id, :harbor_id], unique: true
  end
end
