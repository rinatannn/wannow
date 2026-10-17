
require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "ログインユーザーはコメントを投稿できる" do
    user = users(:one)
    post_record = posts(:one)

    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }
    assert_response :redirect

    assert_difference("Comment.count", 1) do
      post post_comments_path(post_record), params: {
        comment: { body: "テストコメントです" }
      }
    end

    assert_redirected_to post_path(post_record)
    assert_equal user.id, Comment.last.user_id
  end

  test "空のコメントは保存できない" do
    comment = Comment.new(
      user: users(:one),
      post: posts(:one),
      body: ""
    )

    assert_not comment.valid?
    assert_not comment.save
  end


  test "コメント投稿者は自分のコメントを削除できる" do
    user = users(:one)
    comment = comments(:one)

    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }

    assert_difference("Comment.count", -1) do
      delete post_comment_path(comment.post, comment)
    end

    assert_redirected_to post_path(comment.post)
  end



  test "他人のコメントは削除できない" do
    user = users(:two)
    comment = comments(:one)

    post session_path, params: {
      email_address: user.email_address,
      password: "password"
    }

    assert_no_difference("Comment.count") do
      delete post_comment_path(comment.post, comment)
    end

    assert_response :not_found
  end
end
