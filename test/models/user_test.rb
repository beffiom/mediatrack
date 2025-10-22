require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "subscribed? true when status active" do
    u = User.new(email: "a@b.com", subscription_status: "active")
    assert u.subscribed?
  end

  test "subscribed? false when status nil or other" do
    refute User.new(email: "a@b.com").subscribed?
    refute User.new(email: "a@b.com", subscription_status: "canceled").subscribed?
  end
end
