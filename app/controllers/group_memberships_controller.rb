
class GroupMembershipsController < ApplicationController
  before_action :reject_guest, only: %i[create destroy]

  # グループに参加
  def create
    @group = Group.find(params[:group_id])

    membership = Current.user.group_memberships.new(group: @group)

    if membership.save
      redirect_to group_path(@group), notice: "参加申請を送信しました"
    else
      redirect_to group_path(@group), alert: "すでに参加しているグループです"
    end
  end

  # グループから退会
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

  # 参加申請を承認
def approve
  group = Group.find(params[:group_id])

  unless group.user_id == Current.user.id
    return redirect_to group_path(group), alert: "承認する権限がありません"
  end

  membership = group.group_memberships.find(params[:id])

  if membership.pending?
    membership.approved!
    redirect_to group_path(group), notice: "参加申請を承認しました"
  else
    redirect_to group_path(group), alert: "承認待ちの申請ではありません"
  end
end

# 参加申請を拒否
def reject
  group = Group.find(params[:group_id])

  if @group.user_id == Current.user.id
  return redirect_to group_path(@group), alert: "自分が作成したグループには参加申請できません"
end

  unless group.user_id == Current.user.id
    return redirect_to group_path(group), alert: "拒否する権限がありません"
  end

  membership = group.group_memberships.find(params[:id])

  if membership.pending?
    membership.rejected!
    redirect_to group_path(group), notice: "参加申請を拒否しました"
  else
    redirect_to group_path(group), alert: "承認待ちの申請ではありません"
  end
end

  private

  # ゲストユーザーの操作を制限
  def reject_guest
    if Current.user.guest?
      redirect_to groups_path, alert: "ゲストユーザーはグループに参加・退会できません。"
    end
  end
end
