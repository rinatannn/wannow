require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "未ログインユーザーは管理画面にアクセスできない" do
    get admin_users_path

    assert_redirected_to new_session_path
  end

  test "未ログインユーザーは管理者用の詳細画面にアクセスできない" do
    get admin_user_path(1)

    assert_redirected_to new_session_path
  end

  test "管理者はユーザー一覧画面にアクセスできる" do
  post session_path, params: {
    email_address: users(:one).email_address,
    password: "password"
  }

  get admin_users_path

  assert_response :success
end

test "一般ユーザーは管理画面にアクセスできない" do
  post session_path, params: {
    email_address: users(:two).email_address,
    password: "password"
  }

  get admin_users_path

  assert_redirected_to root_path
end

test "管理者は一般ユーザーを利用停止にできる" do
  post session_path, params: {
    email_address: users(:one).email_address,
    password: "password"
  }

  target_user = users(:two)

  patch suspend_admin_user_path(target_user)

  assert_redirected_to admin_user_path(target_user)
  assert_not target_user.reload.is_active?
end

test "一般ユーザーは他のユーザーを利用停止にできない" do
  post session_path, params: {
    email_address: users(:two).email_address,
    password: "password"
  }

  target_user = users(:one)

  patch suspend_admin_user_path(target_user)

  assert_redirected_to root_path
  assert target_user.reload.is_active?
end

test "管理者は自分自身を利用停止にできない" do
  admin = users(:one)

  post session_path, params: {
    email_address: admin.email_address,
    password: "password"
  }

  patch suspend_admin_user_path(admin)

  assert_redirected_to admin_user_path(admin)
  assert admin.reload.is_active?
end

test "管理者はゲストユーザーを利用停止にできない" do
  admin = users(:one)

  post session_path, params: {
    email_address: admin.email_address,
    password: "password"
  }

  guest = User.find_or_create_by!(email_address: User::GUEST_EMAIL) do |user|
    user.name = "ゲスト"
    user.password = SecureRandom.hex(16)
  end

  patch suspend_admin_user_path(guest)

  assert_redirected_to admin_user_path(guest)
  assert guest.reload.is_active?
end
end
