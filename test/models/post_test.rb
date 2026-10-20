require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "テストユーザー",
      email_address: "post-test@example.com",
      password: "password123"
    )
  end

  test "タイトルと本文があれば投稿できる" do
    post = @user.posts.build(title: "初めての投稿", body: "ドッグランに行きました")

    assert post.valid?
  end

  test "タイトルが空欄の場合は投稿できない" do
    post = @user.posts.build(title: "", body: "ドッグランに行きました")

    assert_not post.valid?
    assert_includes post.errors[:title], "を入力してください"
  end

  test "本文が空欄の場合は投稿できない" do
    post = @user.posts.build(title: "初めての投稿", body: "")

    assert_not post.valid?
    assert_includes post.errors[:body], "を入力してください"
  end
end
