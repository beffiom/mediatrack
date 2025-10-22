require "test_helper"
require "minitest/mock"

class UserTest < ActiveSupport::TestCase
  test "subscribed? true when status active" do
    u = User.new(email: "a@b.com", subscription_status: "active")
    assert u.subscribed?
  end

  test "subscribed? false when status nil or other" do
    refute User.new(email: "a@b.com").subscribed?
    refute User.new(email: "a@b.com", subscription_status: "canceled").subscribed?
  end

  test "tmdb_api_key invalid adds validation error" do
    fake_client = Object.new
    def fake_client.valid_key?; false; end

    Tmdb::Client.stub(:new, fake_client) do
      u = User.new(email: "invalid@example.com", password: "password123", tmdb_api_key: "badkey")
      refute u.valid?
      assert_includes u.errors[:tmdb_api_key], "invalid api key"
    end
  end
end
