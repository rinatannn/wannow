class CheckInsController < ApplicationController
  def create
    dog = Current.user.dogs.find(params[:dog_id])
    dog_run = DogRun.find(params[:dog_run_id])

    check_in = CheckIn.new(
      dog: dog,
      dog_run: dog_run,
      checked_in_at: Time.current
    )

    if check_in.save
      redirect_to dog_run_path(dog_run), notice: "チェックインしました"
    else
      redirect_to dog_run_path(dog_run),
                  alert: check_in.errors.full_messages.join(", ")
    end
  end

  def destroy
  check_in = CheckIn.joins(:dog)
                    .where(dogs: { user_id: Current.user.id })
                    .find(params[:id])

  if check_in.checked_out_at.present?
    redirect_to dog_run_path(check_in.dog_run),
                alert: "すでにチェックアウトしています"
  else
    check_in.update!(checked_out_at: Time.current)

    redirect_to dog_run_path(check_in.dog_run),
                notice: "チェックアウトしました"
  end
end

end