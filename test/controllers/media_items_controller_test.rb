require "test_helper"

class MediaItemsControllerTest < ActionDispatch::IntegrationTest
  test "index loads" do
    get media_items_path
    assert_response :success
  end

  test "search loads" do
    get search_media_items_path
    assert_response :success
  end

  test "show loads for existing item" do
    m = MediaItem.create!(tmdb_id: 456, title: "x", media_type: "movie")
    get media_item_path(m)
    assert_response :success
  end
end
