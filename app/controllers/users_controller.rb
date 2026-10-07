class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

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
  end

  # 新規登録
  def create
    @user = User.new(user_params)

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

    if @user.update(user_params)
      redirect_to mypage_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 会員を退会
  def destroy
    @user = Current.user
    @user.destroy
    reset_session
    redirect_to root_path
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