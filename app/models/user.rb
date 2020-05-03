class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :players
  has_many :games, through: :players

  after_save :broadcast_to_games!

  def name
    super || "User #{id}"
  end

  def broadcast_to_games!
    games.each do |game|
      GamesChannel.broadcast_to(game, {})
    end
  end
end
