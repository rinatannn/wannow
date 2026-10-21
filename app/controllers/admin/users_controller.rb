class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
  end

  def suspend
    @user = User.find(params[:id])

    if @user.admin? || @user.guest?
      redirect_to admin_user_path(@user), alert: "このユーザーは利用停止できません。"
    elsif !@user.is_active?
      redirect_to admin_user_path(@user), alert: "すでに利用停止されています。"
    else
      @user.update!(is_active: false)
      @user.sessions.destroy_all

      redirect_to admin_user_path(@user), notice: "ユーザーを利用停止にしました。"
    end
  end

  def reactivate
  @user = User.find(params[:id])

  if @user.admin? || @user.guest?
    redirect_to admin_user_path(@user), alert: "このユーザーは利用再開の対象外です。"
  elsif @user.is_active?
    redirect_to admin_user_path(@user), alert: "すでに利用中です。"
  else
    @user.update!(is_active: true)

    redirect_to admin_user_path(@user), notice: "ユーザーの利用を再開しました。"
  end
end
end
