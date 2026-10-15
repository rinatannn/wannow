class DogRunsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  def index
    @dog_runs = DogRun.all
  end

  def show
    @dog_run = DogRun.find(params[:id])
  end
end
