class Territory < ApplicationRecord
    has_many :adjacencies
    has_one :game, through: :adjacencies
    has_many :borders, -> { distinct }, through: :adjacencies
    has_many :corners, -> { distinct }, through: :adjacencies

    has_many :neighboring_territories, -> { distinct }, through: :borders, source: :territories

    belongs_to_active_hash :terrain

    validates :x, :y, presence: true
end
