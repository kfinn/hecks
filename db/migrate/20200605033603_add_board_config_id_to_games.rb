class AddBoardConfigIdToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :board_config_id, :string, index: true, null: false, default: 'small'
  end
end
