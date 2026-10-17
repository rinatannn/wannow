
require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "ゲストログインできること" do
    post guest_login_path

    assert_redirected_to mypage_path
    assert User.exists?(email_address: User::GUEST_EMAIL)
  end
end
