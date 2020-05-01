class Adjacency < ApplicationRecord
    belongs_to :game
    belongs_to :corner
    belongs_to :border
    belongs_to :territory
end
