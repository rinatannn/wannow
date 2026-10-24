class Admin::DogsController < Admin::BaseController
  def index
    @dogs = Dog.includes(:user).order(created_at: :desc)
  end

  def show
    @dog = Dog.includes(:user).find(params[:id])
  end
end
