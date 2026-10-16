class DogRunsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  def index
    @dog_runs = DogRun.all

    if params[:keyword].present?
      keyword = "%#{DogRun.sanitize_sql_like(params[:keyword])}%"

      @dog_runs = @dog_runs.where(
        "name LIKE :keyword OR address LIKE :keyword",
        keyword: keyword
      )
    end
  end

  def show
    @dog_run = DogRun.find(params[:id])
  end
end
