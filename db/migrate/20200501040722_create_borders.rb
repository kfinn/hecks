class CreateBorders < ActiveRecord::Migration[6.0]
  def change
    create_table :borders do |t|
      t.timestamps
    end
  end
end
