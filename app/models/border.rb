class Border < ApplicationRecord
    has_many :adjacencies
    has_one :game, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies
    has_many :territories, -> { distinct }, through: :adjacencies
end
