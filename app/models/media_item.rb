class MediaItem < ApplicationRecord
  has_many :watchlist_items, dependent: :destroy
  has_many :users, through: :watchlist_items

  validates :tmdb_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :media_type, presence: true
end
