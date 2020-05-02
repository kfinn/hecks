class GameMembership < ApplicationRecord
    belongs_to :game
    belongs_to :user

    delegate :name, to: :user
end
