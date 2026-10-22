require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  test "ログインユーザーは投稿にいいねできる" do
    user = users(:one)
    post_record = posts(:two)

    # ログインする
    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }
    assert_response :redirect

    # いいねが1件増えることを確認
    assert_difference("Like.count", 1) do
      post post_like_path(post_record)
    end

    # いいねしたユーザーと投稿を確認
    like = Like.last
    assert_equal user.id, like.user_id
    assert_equal post_record.id, like.post_id
  end

    test "ログインユーザーは自分のいいねを解除できる" do
    user = users(:one)
    post_record = posts(:one)

    # ログインする
    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }
    assert_response :redirect

    # 既存のいいねがあることを確認
    assert Like.exists?(user: user, post: post_record)

    # いいねが1件減ることを確認
    assert_difference("Like.count", -1) do
      delete post_like_path(post_record)
    end

    # いいねが削除されたことを確認
    assert_not Like.exists?(user: user, post: post_record)
  end

  test "同じ投稿に重複していいねできない" do
    user = users(:one)
    post_record = posts(:one)

    # ログインする
    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }
    assert_response :redirect

    # すでにいいね済みであることを確認
    assert Like.exists?(user: user, post: post_record)

    # もう一度いいねしても件数は増えない
    assert_no_difference("Like.count") do
      post post_like_path(post_record)
    end
  end

  test "未ログインユーザーはいいねできない" do
    post_record = posts(:one)

    assert_no_difference("Like.count") do
      post post_like_path(post_record)
    end

    assert_redirected_to new_session_path
  end

  test "ゲストユーザーはいいねできない" do
    post_record = posts(:one)

    # ゲストログイン
    post guest_login_path
    assert_response :redirect

    # いいねが増えないことを確認
    assert_no_difference("Like.count") do
      post post_like_path(post_record)
    end

    # 投稿一覧に戻されることを確認
    assert_redirected_to posts_path
  end
end