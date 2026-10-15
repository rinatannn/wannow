require "test_helper"

class CheckInsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "テストユーザー",
      email_address: "checkins-controller@example.com",
      password: "password123"
    )

    post session_path, params: {
      email_address: @user.email_address,
      password: "password123"
    }
  end

  test "ログインできる" do
    get mypage_path
    assert_response :success
  end

  test "自分の犬をチェックインできる" do
    dog = Dog.create!(
      user: @user,
      name: "ココ",
      breed: "トイプードル",
      personality: "元気"
    )

    dog_run = DogRun.first

    assert_difference "CheckIn.count", 1 do
      post check_ins_path, params: {
        dog_id: dog.id,
        dog_run_id: dog_run.id
      }
    end

    assert_redirected_to dog_run_path(dog_run)
  end

  test "他人の犬はチェックインできない" do
    other_user = User.create!(
      name: "別のユーザー",
      email_address: "other-checkin@example.com",
      password: "password123"
    )

    other_dog = Dog.create!(
      user: other_user,
      name: "モモ",
      breed: "柴犬",
      personality: "おとなしい"
    )

    dog_run = DogRun.first

    assert_no_difference "CheckIn.count" do
      post check_ins_path, params: {
        dog_id: other_dog.id,
        dog_run_id: dog_run.id
      }
    end

    assert_response :not_found
  end

  test "自分の犬をチェックアウトできる" do
    dog = Dog.create!(
      user: @user,
      name: "ココ",
      breed: "トイプードル",
      personality: "元気"
    )

    dog_run = DogRun.first

    check_in = CheckIn.create!(
      dog: dog,
      dog_run: dog_run,
      checked_in_at: Time.current
    )

    delete check_in_path(check_in)

    assert_not_nil check_in.reload.checked_out_at
    assert_redirected_to dog_run_path(dog_run)
  end

  test "他人の犬はチェックアウトできない" do
    other_user = User.create!(
      name: "別のユーザー",
      email_address: "other-checkout@example.com",
      password: "password123"
    )

    other_dog = Dog.create!(
      user: other_user,
      name: "モモ",
      breed: "柴犬",
      personality: "おとなしい"
    )

    dog_run = DogRun.first

    check_in = CheckIn.create!(
      dog: other_dog,
      dog_run: dog_run,
      checked_in_at: Time.current
    )

    delete check_in_path(check_in)

    assert_response :not_found
    assert_nil check_in.reload.checked_out_at
  end
end
