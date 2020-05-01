class Corner < ApplicationRecord
    has_many :adjacencies
    has_one :game, through: :adjacencies
    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies

    has_many :neighboring_corners, -> { distinct }, through: :borders, source: :corners

    validates :x, :y, presence: true
end
