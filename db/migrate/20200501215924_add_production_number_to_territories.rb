class AddProductionNumberToTerritories < ActiveRecord::Migration[6.0]
  def up
    execute <<~SQL
      TRUNCATE TABLE territories CASCADE;
    SQL

    change_table :territories do |t|
      t.column :production_number_id, :integer, index: true
    end
  end

  def down
    remove_column :territories, :production_number_id
  end
end
