class Territory < ApplicationRecord
    has_many :adjacencies
    has_one :game, through: :adjacencies
    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies

    has_many :neighboring_territories, -> { distinct }, through: :borders, source: :territories

    validates :x, :y, presence: true
end
