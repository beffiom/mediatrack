require "test_helper"

class WatchlistItemsErrorHandlingTest < ActionDispatch::IntegrationTest
  test "duplicate watchlist item shows error instead of 500" do
    u = User.create!(email: "dup@example.com", password: "password123")
    sign_in u, scope: :user
    m = MediaItem.create!(tmdb_id: 4242, title: "t", media_type: "movie")
    post watchlist_items_path, params: { media_item_id: m.id, status: "planned" }
    assert_redirected_to media_items_path

    post watchlist_items_path, params: { media_item_id: m.id, status: "planned" }
    assert_redirected_to media_items_path
    follow_redirect!
    assert_match "has already been taken", @response.body
  end
end
