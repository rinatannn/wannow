
class GroupsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :resume_session, only: [ :index, :show ]

  def index
    @groups = Group.all

    if params[:q].present?
      keyword = "%#{Group.sanitize_sql_like(params[:q])}%"
      @groups = @groups.where(
        "name LIKE :keyword OR description LIKE :keyword",
        keyword: keyword
      )
    end
  end

  def show
    @group = Group.find(params[:id])

    if Current.user && @group.user_id == Current.user.id
      @pending_memberships = @group.group_memberships.pending.includes(:user)
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Current.user.created_groups.new(group_params)

    if @group.save
      redirect_to group_path(@group), notice: "グループを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
