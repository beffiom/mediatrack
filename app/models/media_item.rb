class MediaItem < ApplicationRecord
  has_many :watchlist_items, dependent: :destroy
  has_many :users, through: :watchlist_items

  validates :tmdb_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :media_type, presence: true

  # Clear cache when media item is updated or destroyed
  after_save :clear_media_item_cache
  after_destroy :clear_media_item_cache

  private

  def clear_media_item_cache
    Rails.cache.delete("media_item/tmdb_id:#{tmdb_id}")
  end
end
