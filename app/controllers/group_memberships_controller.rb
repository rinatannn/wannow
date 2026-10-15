class GroupMembershipsController < ApplicationController
  def create
    @group = Group.find(params[:group_id])

    membership = Current.user.group_memberships.new(group: @group)

    if membership.save
      redirect_to group_path(@group), notice: "グループに参加しました"
    else
      redirect_to group_path(@group), alert: "すでに参加しているグループです"
    end
  end

  def destroy
    @group = Group.find(params[:group_id])

    membership = Current.user.group_memberships.find_by(group: @group)

    if membership
      membership.destroy
      redirect_to group_path(@group), notice: "グループから退会しました"
    else
      redirect_to group_path(@group), alert: "参加していないグループです"
    end
  end
end
