class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :players
  has_many :games, through: :players
  has_many :borders, through: :games
  has_many :corners, through: :games
  has_many :territories, through: :games
  has_many :opponent_players, through: :games, source: :players
  has_many :discard_requirements, through: :players
  has_many :player_offers, through: :games
  has_many :player_offer_agreements, through: :games
  has_many :development_cards, through: :players

  after_save :broadcast_to_games!

  def name
    super || "User #{id}"
  end

  def broadcast_to_games!
    games.each(&:changed!)
  end
end
