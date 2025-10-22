class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :watchlist_items, dependent: :destroy
  has_many :media_items, through: :watchlist_items

  # Validate TMDB key when changed and present
  validate :validate_tmdb_api_key, if: :will_validate_tmdb_api_key?

  # Stripe helpers
  def subscribed?
    subscription_status.to_s == "active"
  end

  private

  def will_validate_tmdb_api_key?
    tmdb_api_key.present? && will_save_change_to_tmdb_api_key?
  end

  def validate_tmdb_api_key
    client = Tmdb::Client.new(api_key: tmdb_api_key)
    unless client.valid_key?
      errors.add(:tmdb_api_key, "invalid api key")
    end
  rescue => _e
    errors.add(:tmdb_api_key, "could not verify api key")
  end
end
