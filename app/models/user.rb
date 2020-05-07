class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable, :trackable

  has_many :players
  has_many :games, through: :players
  has_many :borders, through: :games
  has_many :corners, through: :games
  has_many :territories, through: :games
  has_many :opponent_players, through: :games, source: :players

  after_save :broadcast_to_games!

  def name
    super || "User #{id}"
  end

  def broadcast_to_games!
    games.each(&:changed!)
  end
end
