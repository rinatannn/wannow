
class GroupMembershipsController < ApplicationController
  before_action :reject_guest, only: %i[create destroy]

  # グループへの参加申請
  def create
    group = Group.find(params[:group_id])

    # 自分が作成したグループには参加申請できない
    if group.user_id.present? && group.user_id == Current.user.id
      return redirect_to group_path(group),
                         alert: "自分が作成したグループには参加申請できません"
    end

    membership = Current.user.group_memberships.find_or_initialize_by(group: group)

    if membership.new_record? || membership.rejected?
      membership.status = :pending

      if membership.save
        redirect_to group_path(group), notice: "参加申請を送信しました"
      else
        redirect_to group_path(group), alert: "参加申請に失敗しました"
      end
    else
      redirect_to group_path(group),
                  alert: "すでに参加中、または参加申請中です"
    end
  end

  # グループから退会・参加申請を取り消す
  def destroy
    group = Group.find(params[:group_id])
    membership = Current.user.group_memberships.find_by(group: group)

    if membership
      membership.destroy
      redirect_to group_path(group),
                  notice: "退会または参加申請の取り消しが完了しました"
    else
      redirect_to group_path(group), alert: "参加情報がありません"
    end
  end

  # 参加申請を承認
  def approve
    group = Group.find(params[:group_id])

    unless can_manage_memberships?(group)
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

    unless can_manage_memberships?(group)
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

  # 参加申請を管理できるユーザーか確認
  def can_manage_memberships?(group)
    return false unless Current.user

    group.user_id == Current.user.id ||
      (group.user_id.nil? && Current.user.admin?)
  end

  # ゲストユーザーの操作を制限
  def reject_guest
    if Current.user.guest?
      redirect_to groups_path,
                  alert: "ゲストユーザーはグループに参加・退会できません。"
    end
  end
end
