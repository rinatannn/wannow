
require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "ゲストユーザーは退会できないこと" do
    post guest_login_path

    guest = User.find_by!(email_address: User::GUEST_EMAIL)

    assert_no_difference("User.count") do
      delete user_path(guest)
    end

    assert_redirected_to mypage_path
    assert User.exists?(id: guest.id)
  end

  test "ゲストユーザーは会員情報を更新できないこと" do
    post guest_login_path

    guest = User.find_by!(email_address: User::GUEST_EMAIL)

    patch user_path(guest), params: {
      user: {
        name: "変更された名前",
        email_address: "changed@example.com"
      }
    }

    assert_redirected_to mypage_path

    guest.reload
    assert_equal "ゲスト", guest.name
    assert_equal User::GUEST_EMAIL, guest.email_address
  end

  test "通常ユーザーはゲスト専用メールアドレスに変更できないこと" do
    user = User.create!(
      name: "テストユーザー",
      email_address: "normal-user@example.com",
      password: "password123"
    )

    # 通常ユーザーとしてログイン
    post session_path, params: {
      email_address: user.email_address,
      password: "password123"
    }

    # ゲスト専用メールアドレスへの変更を試みる
    patch user_path(user), params: {
      user: {
        name: user.name,
        email_address: User::GUEST_EMAIL
      }
    }

    # 更新が拒否されることを確認
    assert_response :unprocessable_entity

    # 元のメールアドレスが維持されていることを確認
    assert_equal "normal-user@example.com", user.reload.email_address
  end
end
