
class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

# ユーザー一覧・名前検索
def index
  @users = User.where(admin: false, is_active: true)
             .where.not(email_address: User::GUEST_EMAIL)
             .order(:name)
  if params[:keyword].present?
    keyword = "%#{User.sanitize_sql_like(params[:keyword])}%"
    @users = @users.where("name LIKE ?", keyword)
  end
end

  # 新規登録画面を表示
  def new
    @user = User.new
  end

  # マイページを表示
  def show
    @user = User.find(params[:id])
  end

  # 会員情報編集画面を表示
  def edit
    @user = Current.user

    # ゲストユーザーは編集できない
    if @user.guest?
      redirect_to mypage_path, alert: "ゲストユーザーは会員情報を編集できません。"
      return
    end

    # 他のユーザーの編集画面は開けない
    if params[:id].to_i != @user.id
      redirect_to mypage_path
      nil
    end
  end

  # 新規登録
  def create
    @user = User.new(user_params)

    # ゲスト専用メールアドレスでの登録を禁止
    if @user.guest?
      @user.errors.add(:email_address, "は使用できません")
      render :new, status: :unprocessable_entity
      return
    end

    if @user.save
      start_new_session_for @user
      redirect_to mypage_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 会員情報を更新
  def update
    @user = Current.user

    # ゲストユーザーは変更できない
    if @user.guest?
      redirect_to mypage_path, alert: "ゲストユーザーは会員情報を変更できません。"
      return
    end

    # 他のユーザーの情報は変更できない
    if params[:id].to_i != @user.id
      redirect_to mypage_path
      return
    end

    # ゲスト専用メールアドレスへの変更を禁止
    if user_params[:email_address] == User::GUEST_EMAIL
      @user.errors.add(:email_address, "は使用できません")
      render :edit, status: :unprocessable_entity
      return
    end

    if @user.update(user_params)
      redirect_to mypage_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

# 会員を退会
def destroy
  @user = Current.user

  # 他のユーザーのIDでは退会できない
  if params[:id].to_i != @user.id
    redirect_to mypage_path, alert: "他のユーザーの退会操作はできません。"
    return
  end

  # ゲストユーザーは退会できない
  if @user.guest?
    redirect_to mypage_path, alert: "ゲストユーザーは退会できません。"
    return
  end

  @user.destroy
  reset_session
  redirect_to new_user_path
end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email_address,
      :password,
      :password_confirmation
    )
  end
end
