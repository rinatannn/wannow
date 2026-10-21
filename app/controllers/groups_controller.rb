class GroupsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
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