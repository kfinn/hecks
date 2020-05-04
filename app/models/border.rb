class Border < ApplicationRecord
    has_many :adjacencies
    has_one :arbitrary_adjacency, class_name: 'Adjacency'
    has_one :game, through: :arbitrary_adjacency
    has_many :corners, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

    has_one :road

    validates :x, :y, presence: true
end
