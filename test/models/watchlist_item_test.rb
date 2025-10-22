require "test_helper"

class WatchlistItemTest < ActiveSupport::TestCase
  test "uniqueness per user and media_item" do
    u = User.create!(email: "u@example.com", password: "password123")
    m = MediaItem.create!(tmdb_id: 999, title: "t", media_type: "movie")
    wi1 = WatchlistItem.create!(user: u, media_item: m, status: "planned")
    wi2 = WatchlistItem.new(user: u, media_item: m, status: "planned")
    refute wi2.valid?
    assert_includes wi2.errors.attribute_names, :media_item_id
  end
end
