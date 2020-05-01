class CreateCorners < ActiveRecord::Migration[6.0]
  def change
    create_table :corners do |t|
      t.timestamps
    end
  end
end
