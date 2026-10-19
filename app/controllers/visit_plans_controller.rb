
class VisitPlansController < ApplicationController
  before_action :require_authentication, only: %i[create destroy]
  before_action :reject_guest, only: %i[create destroy]

# 来場予定一覧・カレンダー表示
def index
  @visit_plans = VisitPlan
    .includes(:dog, :dog_run)
    .where("planned_at >= ?", Time.current)
    .order(:planned_at)

  @calendar_plans = @visit_plans.group_by do |visit_plan|
    visit_plan.planned_at.to_date
  end
end

  # 来場予定を登録
  def create
    dog = Current.user.dogs.find(params[:dog_id])
    dog_run = DogRun.find(params[:dog_run_id])

    visit_plan = VisitPlan.new(
      dog: dog,
      dog_run: dog_run,
      planned_at: params[:planned_at]
    )

    if visit_plan.save
      redirect_to dog_run_path(dog_run), notice: "来場予定を登録しました"
    else
      redirect_to dog_run_path(dog_run),
                  alert: visit_plan.errors.full_messages.join("、")
    end
  end

  # 来場予定をキャンセル
  def destroy
    visit_plan = VisitPlan.joins(:dog)
                         .where(dogs: { user_id: Current.user.id })
                         .find(params[:id])

    dog_run = visit_plan.dog_run
    visit_plan.destroy!

    redirect_to dog_run_path(dog_run), notice: "来場予定をキャンセルしました"
  end

  private

  # ゲストユーザーの操作を制限
  def reject_guest
    if Current.user.guest?
      redirect_to visit_plans_path, alert: "ゲストユーザーは来場予定を登録・キャンセルできません。"
    end
  end
end
