class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :players
  has_many :games, through: :players

  def name
    super || "User #{id}"
  end
end
