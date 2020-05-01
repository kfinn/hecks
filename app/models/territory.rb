class Territory < ApplicationRecord
    has_many :adjacencies
    has_one :game, through: :adjacencies
    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies

    has_many :neighboring_territories, -> { distinct }, through: :borders, source: :territories

    belongs_to_active_hash :terrain
    belongs_to_active_hash :production_number

    validates :x, :y, :terrain, presence: true
    validates :production_number, presence: true, unless: :desert?

    def desert?
        terrain == Terrain::DESERT
    end
end
