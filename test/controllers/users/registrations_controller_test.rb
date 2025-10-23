require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      username: "testuser",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "destroy with correct password deletes account" do
    post user_session_path, params: { user: { username: @user.username, password: "password123" } }
    assert_difference("User.count", -1) do
      delete user_registration_path, params: { current_password: "password123" }
    end
    assert_redirected_to root_path
  end

  test "destroy with incorrect password does not delete account" do
    post user_session_path, params: { user: { username: @user.username, password: "password123" } }
    assert_no_difference("User.count") do
      delete user_registration_path, params: { current_password: "wrongpassword" }
    end
    assert_redirected_to edit_user_registration_path
    assert_equal "incorrect password", flash[:alert]
  end

  test "destroy without password does not delete account" do
    post user_session_path, params: { user: { username: @user.username, password: "password123" } }
    assert_no_difference("User.count") do
      delete user_registration_path, params: { current_password: "" }
    end
    assert_redirected_to edit_user_registration_path
    assert_equal "incorrect password", flash[:alert]
  end
end
