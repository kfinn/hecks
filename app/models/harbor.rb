class Harbor < ApplicationRecord
    belongs_to_active_hash :harbor_offer

    has_many :corner_harbors
    has_many :corners, through: :corner_harbors

    validates :harbor_offer, :x, :y, presence: true
end
