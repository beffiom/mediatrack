class WatchlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :media_item
end
