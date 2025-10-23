require "test_helper"

class MediaItemsControllerTest < ActionDispatch::IntegrationTest
  test "search handles missing tmdb key" do
    get search_media_items_path, params: { q: "matrix" }
    assert_response :success
    assert_match "tmdb", @response.body
  end

  test "search handles invalid tmdb key" do
    fake_client = Object.new
    def fake_client.search_multi(*) = (raise Tmdb::HttpError.new(401, "unauthorized"))

    Tmdb::Client.stub(:new, ->(*) { fake_client }) do
      get search_media_items_path, params: { q: "matrix" }
      assert_response :success
      assert_match "invalid tmdb api key", @response.body
    end
  end

  test "search handles tmdb server error" do
    fake_client = Object.new
    def fake_client.search_multi(*) = (raise Tmdb::HttpError.new(500, "oops"))

    Tmdb::Client.stub(:new, ->(*) { fake_client }) do
      get search_media_items_path, params: { q: "matrix" }
      assert_response :success
      assert_match "tmdb error", @response.body
    end
  end
end
