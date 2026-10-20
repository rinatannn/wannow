
require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    test "ユーザー名で検索できること" do
    user = User.create!(
      name: "検索テスト太郎",
      email_address: "search-test@example.com",
      password: "password123"
    )

    post session_path, params: {
      email_address: user.email_address,
      password: "password123"
    }

    get users_path, params: { keyword: "検索テスト" }

    assert_response :success
    assert_select "a[href='#{user_path(user)}']", text: "検索テスト太郎"
  end

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

    test "管理者はユーザー検索結果に表示されないこと" do
    user = users(:two)
    admin = users(:one)

    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }

    get users_path, params: { keyword: admin.name }

    assert_response :success
    assert_select "a[href='#{user_path(admin)}']", count: 0
  end

    test "利用停止ユーザーは検索結果に表示されないこと" do
    user = users(:two)

    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }

    suspended_user = User.create!(
      name: "利用停止テストユーザー",
      email_address: "suspended-search@example.com",
      password: "password123",
      is_active: false
    )

    get users_path, params: { keyword: "利用停止テスト" }

    assert_response :success
    assert_select "a[href='#{user_path(suspended_user)}']", count: 0
  end

  test "ゲストユーザーは検索結果に表示されないこと" do
  user = users(:two)

  post session_path, params: {
    email_address: user.email_address,
    password: "password"
  }

  guest = User.find_or_create_by!(email_address: User::GUEST_EMAIL) do |u|
    u.name = "ゲスト"
    u.password = "password123"
  end

  get users_path, params: { keyword: "ゲスト" }

  assert_response :success
  assert_select "a[href='#{user_path(guest)}']", count: 0
end

  test "他人のIDを指定しても退会できないこと" do
    user = users(:two)
    other_user = User.create!(
      name: "別のユーザー",
      email_address: "other-delete-test@example.com",
      password: "password123"
    )

    # 通常ユーザーとしてログイン
    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }

    # 他人のIDを指定して退会を試みる
    assert_no_difference("User.count") do
      delete user_path(other_user)
    end

    assert_redirected_to mypage_path

    # 本人も相手も削除されていないことを確認
    assert User.exists?(id: user.id)
    assert User.exists?(id: other_user.id)
  end

    test "他人のプロフィールでは個人情報と編集・退会ボタンを表示しないこと" do
    user = users(:two)

    other_user = User.create!(
      name: "プロフィール確認ユーザー",
      email_address: "profile-check@example.com",
      password: "password123"
    )

    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }

    get user_path(other_user)

    assert_response :success
    assert_select "h1", text: "ユーザープロフィール"
    assert_select "body", text: /プロフィール確認ユーザー/
    assert_select "body", text: /profile-check@example.com/, count: 0
    assert_select "a[href='#{edit_user_path(other_user)}']", count: 0
    assert_select "form[action='#{user_path(other_user)}'][method='post']", count: 0
  end

    test "自分のプロフィールでは会員情報と編集・退会ボタンを表示すること" do
    user = users(:two)

    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }

    get user_path(user)

    assert_response :success
    assert_select "h1", text: "マイページ"
    assert_select "body", text: /#{Regexp.escape(user.email_address)}/
    assert_select "a[href='#{edit_user_path(user)}']", text: "会員情報を編集する"
    assert_select "form[action='#{user_path(user)}'][method='post']", count: 1
  end
end
