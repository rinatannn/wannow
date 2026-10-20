class Admin::SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to admin_login_path, alert: "しばらく時間をおいて再度お試しください。" }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    if user&.admin? && user.is_active?
      start_new_session_for user
      redirect_to admin_users_path, notice: "管理者としてログインしました。"
    else
      redirect_to admin_login_path, alert: "ログイン情報が正しくないか、管理者権限がありません。"
    end
  end
end
