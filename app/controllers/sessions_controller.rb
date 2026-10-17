
class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create guest]

  # ログイン試行回数を制限する
  rate_limit to: 10, within: 3.minutes, only: %i[create guest],
             with: -> { redirect_to new_session_url, alert: "しばらく時間をおいて再度お試しください。" }

  # ログイン画面
  def new
  end

  # 通常ログイン
  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to mypage_path
    else
      redirect_to new_session_path, alert: "メールアドレスまたはパスワードが正しくありません。"
    end
  end

  # ゲストログイン
  def guest
    user = User.find_or_create_by!(email_address: User::GUEST_EMAIL) do |guest_user|
      guest_user.name = "ゲスト"
      guest_user.password = SecureRandom.hex(16)
    end

    start_new_session_for user
    redirect_to mypage_path, notice: "ゲストとしてログインしました。"
  end

  # ログアウト
  def destroy
    terminate_session
    redirect_to about_path
  end
end
