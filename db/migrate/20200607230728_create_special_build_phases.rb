class CreateSpecialBuildPhases < ActiveRecord::Migration[6.0]
  def change
    create_table :special_build_phases do |t|
      t.belongs_to :player, foreign_key: true, null: false
      t.belongs_to :turn, foreign_key: true, null: false

      t.timestamps
    end

    add_idnex :special_build_phases, [:player, :turn], unique: true
  end
end
