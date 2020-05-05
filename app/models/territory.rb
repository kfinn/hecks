class Territory < ApplicationRecord
    has_many :adjacencies
    has_one :game, through: :adjacencies
    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies

    has_many :settlements, -> { distinct }, through: :corners

    belongs_to_active_hash :terrain
    belongs_to_active_hash :production_number

    delegate :resource, to: :terrain

    validates :x, :y, :terrain, presence: true
    validates :production_number, presence: true, unless: :desert?

    def desert?
        terrain == Terrain::DESERT
    end
end
