require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  test "webhook endpoint accepts post" do
    post "/stripe/webhook", params: {}.to_json, headers: { "CONTENT_TYPE" => "application/json" }
    assert_response :success
  end
end
