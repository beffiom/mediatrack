require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "new requires login" do
    get new_subscription_path
    assert_redirected_to new_user_session_path
  end

  test "create without price id redirects with alert" do
    u = User.create!(email: "sub@example.com", password: "password123")
sign_in u, scope: :user
    post subscriptions_path
    assert_redirected_to root_path
  end
end
