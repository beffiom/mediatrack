require "test_helper"

class SubscriptionsErrorHandlingTest < ActionDispatch::IntegrationTest
  test "stripe errors are surfaced as alerts" do
    u = User.create!(email: "stripe@example.com", password: "password123")
    sign_in u, scope: :user

    ENV.stub(:[], ->(k) { k == "STRIPE_PRICE_ID" ? "price_123" : nil }) do
      Stripe::Customer.stub(:create, ->(*) { raise Stripe::StripeError.new("boom") }) do
        post subscriptions_path
        assert_redirected_to root_path
        follow_redirect!
        assert_match "stripe error", @response.body
      end
    end
  end
end
