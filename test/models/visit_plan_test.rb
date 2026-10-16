require "test_helper"

class VisitPlanTest < ActiveSupport::TestCase
  setup do
    @dog = dogs(:one)
    @dog_run = dog_runs(:one)
  end

  test "未来の日時なら登録できる" do
    visit_plan = VisitPlan.new(
      dog: @dog,
      dog_run: @dog_run,
      planned_at: 1.day.from_now
    )

    assert visit_plan.valid?
  end

  test "過去の日時なら登録できない" do
    visit_plan = VisitPlan.new(
      dog: @dog,
      dog_run: @dog_run,
      planned_at: 1.day.ago
    )

    assert_not visit_plan.valid?
    assert visit_plan.errors[:planned_at].any?
  end

  test "日時が未入力なら登録できない" do
    visit_plan = VisitPlan.new(
      dog: @dog,
      dog_run: @dog_run,
      planned_at: nil
    )

    assert_not visit_plan.valid?
  end
end
