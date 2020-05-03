class RenameGameMembershipsToPlayers < ActiveRecord::Migration[6.0]
  def change
    rename_table :game_memberships, :players
  end
end
