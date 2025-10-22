require "test_helper"

class MediaItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get media_items_index_url
    assert_response :success
  end

  test "should get show" do
    get media_items_show_url
    assert_response :success
  end

  test "should get search" do
    get media_items_search_url
    assert_response :success
  end
end
