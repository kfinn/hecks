class AddUniqueIndexToDevelopmentCards < ActiveRecord::Migration[6.0]
  def change
    add_index :development_cards, [:game_id, :ordering], unique: true
  end
end
