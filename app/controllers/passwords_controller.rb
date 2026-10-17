
class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[edit update]

  # パスワード再設定画面
  def new
  end

  # パスワード再設定メールを送信
  def create
    user = User.find_by(email_address: params[:email_address])

    # ゲストユーザーには再設定メールを送らない
    if user && !user.guest?
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path,
                notice: "登録されているメールアドレスには、パスワード再設定の案内を送信しました。"
  end

  # パスワード変更画面
  def edit
  end

  # パスワードを更新
  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "パスワードを変更しました。"
    else
      redirect_to edit_password_path(params[:token]),
                  alert: "パスワードが一致しません。"
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_password_reset_token!(params[:token])

    # ゲストユーザーのパスワード変更を禁止
    if @user.guest?
      redirect_to new_session_path,
                  alert: "ゲストユーザーのパスワードは変更できません。"
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path,
                alert: "パスワード再設定リンクが無効、または期限切れです。"
  end
end
