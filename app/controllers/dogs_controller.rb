class DogsController < ApplicationController
  def new
    @dog = Dog.new
  end

  def create
    @dog = Current.user.dogs.build(dog_params)

    if @dog.save
      redirect_to dog_path(@dog), notice: "愛犬のプロフィールを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  @dog = Current.user.dogs.find(params[:id])
end

def edit
  @dog = Current.user.dogs.find(params[:id])
end

def update
  @dog = Current.user.dogs.find(params[:id])

  if @dog.update(dog_params)
    redirect_to dog_path(@dog), notice: "愛犬のプロフィールを更新しました"
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @dog = Current.user.dogs.find(params[:id])
  @dog.destroy!
  redirect_to new_dog_path, notice: "愛犬のプロフィールを削除しました", status: :see_other
end

  private

  def dog_params
    params.require(:dog).permit(:name, :breed, :personality)
  end
end