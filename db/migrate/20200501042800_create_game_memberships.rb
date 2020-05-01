class CreateGameMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :game_memberships do |t|
      t.belongs_to :game, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
