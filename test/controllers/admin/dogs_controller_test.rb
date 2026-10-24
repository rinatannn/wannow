require "test_helper"

class Admin::DogsControllerTest < ActionDispatch::IntegrationTest
  # 管理者は愛犬一覧を表示できる
  test "管理者は愛犬一覧を表示できる" do
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    get admin_dogs_path

    assert_response :success
    assert_select "td", text: dogs(:one).name
    assert_select "td", text: dogs(:two).name
  end

  # 管理者は愛犬詳細を表示できる
  test "管理者は愛犬詳細を表示できる" do
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    get admin_dog_path(dogs(:two))

    assert_response :success
    assert_select "body", text: /#{Regexp.escape(dogs(:two).breed)}/
    assert_select "a[href='#{admin_user_path(users(:two))}']"
  end

  # 未ログインユーザーは愛犬一覧を表示できない
  test "未ログインユーザーは愛犬一覧を表示できない" do
    get admin_dogs_path

    assert_redirected_to new_session_path
  end

  # 未ログインユーザーは愛犬詳細を表示できない
  test "未ログインユーザーは愛犬詳細を表示できない" do
    get admin_dog_path(dogs(:one))

    assert_redirected_to new_session_path
  end

  # 一般ユーザーは愛犬一覧を表示できない
  test "一般ユーザーは愛犬一覧を表示できない" do
    post session_path, params: {
      email_address: users(:two).email_address,
      password: "password"
    }

    get admin_dogs_path

    assert_redirected_to root_path
  end

  # 一般ユーザーは愛犬詳細を表示できない
  test "一般ユーザーは愛犬詳細を表示できない" do
    post session_path, params: {
      email_address: users(:two).email_address,
      password: "password"
    }

    get admin_dog_path(dogs(:one))

    assert_redirected_to root_path
  end
end
