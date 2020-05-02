class AddKeyToGames < ActiveRecord::Migration[6.0]
  def change
    execute <<~SQL
      TRUNCATE TABLE games CASCADE;
    SQL

    add_column :games, :key, :text, null: false, index: { unique: true }
  end
end
