require "test_helper"

class VisitPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "テストユーザー",
      email_address: "visitplans-controller@example.com",
      password: "password123"
    )

    post session_path, params: {
      email_address: @user.email_address,
      password: "password123"
    }
  end

  test "should get index" do
    get visit_plans_url
    assert_response :success
  end

  test "自分の犬の来場予定を登録できる" do
    dog = Dog.create!(
      user: @user,
      name: "ココ",
      breed: "トイプードル",
      personality: "元気"
    )

    dog_run = DogRun.first

    assert_difference "VisitPlan.count", 1 do
      post visit_plans_path, params: {
        dog_id: dog.id,
        dog_run_id: dog_run.id,
        planned_at: 1.day.from_now
      }
    end

    assert_redirected_to dog_run_path(dog_run)
  end

  test "他人の犬の来場予定は登録できない" do
    other_user = User.create!(
      name: "別のユーザー",
      email_address: "other-visitplan@example.com",
      password: "password123"
    )

    other_dog = Dog.create!(
      user: other_user,
      name: "モモ",
      breed: "柴犬",
      personality: "おとなしい"
    )

    dog_run = DogRun.first

    assert_no_difference "VisitPlan.count" do
      post visit_plans_path, params: {
        dog_id: other_dog.id,
        dog_run_id: dog_run.id,
        planned_at: 1.day.from_now
      }
    end

    assert_response :not_found
  end

    test "自分の犬の来場予定をキャンセルできる" do
    dog = Dog.create!(
      user: @user,
      name: "ココ",
      breed: "トイプードル",
      personality: "元気"
    )

    dog_run = DogRun.first

    visit_plan = VisitPlan.create!(
      dog: dog,
      dog_run: dog_run,
      planned_at: 1.day.from_now
    )

    assert_difference "VisitPlan.count", -1 do
      delete visit_plan_path(visit_plan)
    end

    assert_redirected_to dog_run_path(dog_run)
  end

    test "他人の犬の来場予定はキャンセルできない" do
    other_user = User.create!(
      name: "別のユーザー",
      email_address: "other-cancel-visitplan@example.com",
      password: "password123"
    )

    other_dog = Dog.create!(
      user: other_user,
      name: "モモ",
      breed: "柴犬",
      personality: "おとなしい"
    )

    dog_run = DogRun.first

    visit_plan = VisitPlan.create!(
      dog: other_dog,
      dog_run: dog_run,
      planned_at: 1.day.from_now
    )

    assert_no_difference "VisitPlan.count" do
      delete visit_plan_path(visit_plan)
    end

    assert_response :not_found
    assert VisitPlan.exists?(visit_plan.id)
  end
end
