
require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "投稿テストユーザー",
      email_address: "posts-controller@example.com",
      password: "password123"
    )

    post session_path, params: {
      email_address: @user.email_address,
      password: "password123"
    }

    @post = @user.posts.create!(
      title: "テスト投稿",
      body: "テスト本文"
    )
  end

  test "投稿一覧を表示できる" do
    get posts_path
    assert_response :success
  end

  test "投稿詳細を表示できる" do
    get post_path(@post)
    assert_response :success
  end

  test "新規投稿画面を表示できる" do
    get new_post_path
    assert_response :success
  end

  test "自分の投稿の編集画面を表示できる" do
    get edit_post_path(@post)
    assert_response :success
  end

  test "投稿を新規作成できる" do
    assert_difference "Post.count", 1 do
      post posts_path, params: {
        post: {
          title: "新しい投稿",
          body: "新しい本文"
        }
      }
    end

    assert_redirected_to post_path(Post.order(:id).last)
  end

  test "自分の投稿を更新できる" do
    patch post_path(@post), params: {
      post: {
        title: "更新後のタイトル",
        body: "更新後の本文"
      }
    }

    assert_redirected_to post_path(@post)
    assert_equal "更新後のタイトル", @post.reload.title
    assert_equal "更新後の本文", @post.body
  end

  test "自分の投稿を削除できる" do
    assert_difference "Post.count", -1 do
      delete post_path(@post)
    end

    assert_redirected_to posts_path
  end

  test "他人の投稿は編集できない" do
    other_user = User.create!(
      name: "別のユーザー",
      email_address: "other-posts@example.com",
      password: "password123"
    )
    other_post = other_user.posts.create!(
      title: "他人の投稿",
      body: "他人の本文"
    )

    get edit_post_path(other_post)

    assert_response :not_found
  end

  test "他人の投稿は更新できない" do
    other_user = User.create!(
      name: "別のユーザー",
      email_address: "other-update@example.com",
      password: "password123"
    )
    other_post = other_user.posts.create!(
      title: "他人の投稿",
      body: "元の本文"
    )

    patch post_path(other_post), params: {
      post: {
        title: "不正な変更",
        body: "変更後の本文"
      }
    }

    assert_response :not_found
    assert_equal "他人の投稿", other_post.reload.title
    assert_equal "元の本文", other_post.body
  end

  test "他人の投稿は削除できない" do
    other_user = User.create!(
      name: "別のユーザー",
      email_address: "other-delete@example.com",
      password: "password123"
    )
    other_post = other_user.posts.create!(
      title: "他人の投稿",
      body: "他人の本文"
    )

    assert_no_difference "Post.count" do
      delete post_path(other_post)
    end

    assert_response :not_found
  end
end
