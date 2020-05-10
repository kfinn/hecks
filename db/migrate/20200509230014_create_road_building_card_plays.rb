class CreateRoadBuildingCardPlays < ActiveRecord::Migration[6.0]
  def change
    create_table :road_building_card_plays do |t|
      t.references :development_card, foreign_key: true, null: false

      t.references :road_1, foreign_key: { to_table: :roads }
      t.references :road_2, foreign_key: { to_table: :roads }

      t.timestamps
    end
  end
end
