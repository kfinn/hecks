class Territory < ApplicationRecord
    has_many :adjacencies
    has_one :arbitrary_adjacency, class_name: 'Adjacency'
    has_one :game, through: :arbitrary_adjacency
    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies

    has_many :settlements, -> { distinct }, through: :corners
    has_many :players, -> { distinct }, through: :settlements

    belongs_to_active_hash :terrain
    belongs_to_active_hash :production_number

    delegate :resource, to: :terrain

    validates :x, :y, :terrain, presence: true
    validates :production_number, presence: true, unless: :desert?

    def self.without_robber
        where.not(id: Game.all.select(:robber_territory_id))
    end

    def desert?
        terrain == Terrain::DESERT
    end

    def has_robber?
        self == game.robber_territory
    end
end
