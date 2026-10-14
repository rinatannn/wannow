require "test_helper"

class UserTest < ActiveSupport::TestCase
  # 同じメールアドレスでは登録できないことを確認する
  test "email address must be unique" do
    # 1人目のユーザーを作成する
    User.create!(
      name: "テストユーザー1",
      email_address: "duplicate@example.com",
      password: "password123"
    )

    # 同じメールアドレスで2人目のユーザーを準備する
    user = User.new(
      name: "テストユーザー2",
      email_address: "duplicate@example.com",
      password: "password123"
    )

    # バリデーションに失敗することを確認する
    assert_not user.valid?

    # メールアドレスの重複エラーが登録されることを確認する
    assert user.errors.added?(:email_address, :taken)
  end
end