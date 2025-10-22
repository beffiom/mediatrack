require "test_helper"

class WatchlistItemsControllerTest < ActionDispatch::IntegrationTest
  test "requires auth for create" do
    m = MediaItem.create!(tmdb_id: 777, title: "y", media_type: "movie")
    post watchlist_items_path, params: { media_item_id: m.id }
    assert_redirected_to new_user_session_path
  end

  test "create as signed in user" do
    u = User.create!(email: "it@example.com", password: "password123")
sign_in u, scope: :user
    m = MediaItem.create!(tmdb_id: 778, title: "z", media_type: "movie")
    assert_difference -> { WatchlistItem.count }, +1 do
      post watchlist_items_path, params: { media_item_id: m.id, status: "planned" }
    end
    assert_redirected_to media_items_path
  end
end
