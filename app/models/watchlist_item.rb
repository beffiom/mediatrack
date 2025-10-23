class WatchlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :media_item

  validates :media_item_id, uniqueness: { scope: :user_id }

  # Clear user's watchlist cache when items are modified
  after_save :clear_user_watchlist_cache
  after_destroy :clear_user_watchlist_cache

  private

  def clear_user_watchlist_cache
    # Clear cache for all media types since we don't know which one changed
    %w[movie tv anime].each do |type|
      Rails.cache.delete("user/#{user_id}/watchlist/#{type}")
    end
  end
end
