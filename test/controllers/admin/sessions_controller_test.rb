require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "管理者ログイン画面を表示できること" do
    get admin_login_path

    assert_response :success
  end

  test "管理者はログインできること" do
    post admin_login_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    assert_redirected_to admin_users_path
  end

  test "一般ユーザーは管理者としてログインできないこと" do
    post admin_login_path, params: {
      email_address: users(:two).email_address,
      password: "password"
    }

    assert_redirected_to admin_login_path
  end
end