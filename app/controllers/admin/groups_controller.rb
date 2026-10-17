
class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: %i[show edit update destroy]

  def index
    @groups = Group.order(:name)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to admin_group_path(@group), notice: "グループを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to admin_group_path(@group), notice: "グループを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to admin_groups_path, notice: "グループを削除しました。"
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
