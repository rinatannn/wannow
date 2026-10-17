
require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "ゲストユーザーにはパスワード再設定メールを送信しないこと" do
    post guest_login_path

    assert_no_enqueued_emails do
      post passwords_path, params: {
        email_address: User::GUEST_EMAIL
      }
    end

    assert_redirected_to new_session_path
  end

  test "ゲストユーザーは再設定トークンでパスワードを変更できないこと" do
    post guest_login_path

    guest = User.find_by!(email_address: User::GUEST_EMAIL)
    original_password_digest = guest.password_digest
    token = guest.password_reset_token

    patch password_path(token), params: {
      password: "newpassword123",
      password_confirmation: "newpassword123"
    }

    assert_redirected_to new_session_path
    assert_equal original_password_digest, guest.reload.password_digest
  end
end
