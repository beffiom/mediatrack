require "test_helper"
require "minitest/mock"

class UserTest < ActiveSupport::TestCase
  test "subscribed? true when status active" do
    u = User.new(username: "testuser", email: "a@b.com", subscription_status: "active")
    assert u.subscribed?
  end

  test "subscribed? false when status nil or other" do
    refute User.new(username: "testuser", email: "a@b.com").subscribed?
    refute User.new(username: "testuser", email: "a@b.com", subscription_status: "canceled").subscribed?
  end

  test "username must be present" do
    u = User.new(email: "test@example.com", password: "password123")
    refute u.valid?
    assert_includes u.errors[:username], "can't be blank"
  end

  test "username must be unique" do
    User.create!(username: "existinguser", email: "user1@example.com", password: "password123")
    u = User.new(username: "existinguser", email: "user2@example.com", password: "password123")
    refute u.valid?
    assert_includes u.errors[:username], "has already been taken"
  end

  test "username uniqueness is case insensitive" do
    User.create!(username: "TestUser", email: "user1@example.com", password: "password123")
    u = User.new(username: "testuser", email: "user2@example.com", password: "password123")
    refute u.valid?
    assert_includes u.errors[:username], "has already been taken"
  end

  test "user can be created without email" do
    u = User.new(username: "newuser", password: "password123", password_confirmation: "password123")
    assert u.valid?
    assert u.save
  end

  test "user can be created with email" do
    u = User.new(username: "newuser2", email: "user@example.com", password: "password123", password_confirmation: "password123")
    assert u.valid?
    assert u.save
  end

  test "tmdb_api_key invalid adds validation error" do
    fake_client = Object.new
    def fake_client.valid_key?; false; end

    Tmdb::Client.stub(:new, fake_client) do
      u = User.new(username: "testuser", email: "invalid@example.com", password: "password123", tmdb_api_key: "badkey")
      refute u.valid?
      assert_includes u.errors[:tmdb_api_key], "invalid api key"
    end
  end
end
