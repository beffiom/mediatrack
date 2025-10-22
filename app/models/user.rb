class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :watchlist_items, dependent: :destroy
  has_many :media_items, through: :watchlist_items

  # Stripe helpers
  def subscribed?
    subscription_status.to_s == "active"
  end
end
