require "test_helper"

class Admin::CommentsControllerTest < ActionDispatch::IntegrationTest
  test "未ログインユーザーはコメント管理画面にアクセスできない" do
    get admin_comments_path

    assert_redirected_to new_session_path
  end

  test "管理者はコメント一覧を表示できる" do
    login_as(users(:one))

    get admin_comments_path

    assert_response :success
    assert_select "td", text: comments(:one).body
  end

  test "一般ユーザーはコメント管理画面にアクセスできない" do
    login_as(users(:two))

    get admin_comments_path

    assert_redirected_to root_path
  end

  test "管理者はコメントを削除できる" do
    login_as(users(:one))

    assert_difference("Comment.count", -1) do
      delete admin_comment_path(comments(:one))
    end

    assert_redirected_to admin_comments_path
  end

  test "一般ユーザーはコメントを削除できない" do
    login_as(users(:two))

    assert_no_difference("Comment.count") do
      delete admin_comment_path(comments(:one))
    end

    assert_redirected_to root_path
  end

  private

  def login_as(user)
    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }
  end
end
