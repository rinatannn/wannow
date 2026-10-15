class GroupsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end
end
