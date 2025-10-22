class WatchlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :media_item

  validates :media_item_id, uniqueness: { scope: :user_id }
end
