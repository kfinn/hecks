class Corner < ApplicationRecord
    has_many :adjacencies
    has_one :arbitrary_adjacency, class_name: 'Adjacency'
    has_one :game, through: :arbitrary_adjacency
    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

    has_many :neighboring_corners, -> { distinct }, through: :borders, source: :corners
    has_many :neighboring_settlements, -> { distinct }, through: :neighboring_corners, source: :settlement
    has_one :settlement

    validates :x, :y, presence: true

    def self.available_for_settlement
        where.not(id: Settlement.all.joins(:neighboring_corners).select('corners.id'))
    end
end
