class RemoveHasRobbablePlayersFromRobberMoveRequirements < ActiveRecord::Migration[6.0]
  def change
    remove_column :robber_move_requirements, :has_robbable_players, :boolean, null: false, default: false
  end
end
