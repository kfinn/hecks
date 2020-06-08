class AddSpecialBuildPhaseIdToTurns < ActiveRecord::Migration[6.0]
  def change
    add_reference :turns, :special_build_phase
  end
end
