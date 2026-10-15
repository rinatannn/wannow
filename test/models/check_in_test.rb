require "test_helper"

class CheckInTest < ActiveSupport::TestCase
  test "同じ犬は二重チェックインできない" do
    user = User.create!(
  name: "テストユーザー",
  email_address: "checkin-test@example.com",
  password: "password123"
)

    dog = Dog.create!(
      user: user,
      name: "ココ",
      breed: "トイプードル",
      personality: "元気"
    )

    dog_run = DogRun.first

    CheckIn.create!(
      dog: dog,
      dog_run: dog_run,
      checked_in_at: Time.current
    )

    second_check_in = CheckIn.new(
      dog: dog,
      dog_run: dog_run,
      checked_in_at: Time.current
    )

    assert_not second_check_in.valid?
  end

  test "チェックアウト後は再チェックインできる" do
  user = User.create!(
    name: "テストユーザー2",
    email_address: "recheckin-test@example.com",
    password: "password123"
  )

  dog = Dog.create!(
    user: user,
    name: "モモ",
    breed: "柴犬",
    personality: "おとなしい"
  )

  dog_run = DogRun.first

  CheckIn.create!(
    dog: dog,
    dog_run: dog_run,
    checked_in_at: 1.hour.ago,
    checked_out_at: Time.current
  )

  new_check_in = CheckIn.new(
    dog: dog,
    dog_run: dog_run,
    checked_in_at: Time.current
  )

  assert new_check_in.valid?
end

end