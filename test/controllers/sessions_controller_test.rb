
require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "ゲストログインできること" do
    post guest_login_path

    assert_redirected_to mypage_path
    assert User.exists?(email_address: User::GUEST_EMAIL)
  end

    test "利用停止ユーザーはログインできないこと" do
    user = users(:two)
    user.update!(is_active: false)

    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }

    assert_redirected_to new_session_path
    assert_equal "このアカウントは利用停止されています。", flash[:alert]
  end
end
