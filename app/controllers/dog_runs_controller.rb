class DogRunsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  def index
    @dog_runs = DogRun.all

  # キーワード検索（既存機能）
  if params[:keyword].present?
    keyword = "%#{DogRun.sanitize_sql_like(params[:keyword])}%"

    @dog_runs = @dog_runs.where(
      "name LIKE :keyword OR address LIKE :keyword",
      keyword: keyword
    )
  end

  # 都道府県による絞り込み
  if params[:prefecture].present?
    prefecture = "#{DogRun.sanitize_sql_like(params[:prefecture])}%"

    @dog_runs = @dog_runs.where(
      "address LIKE ?", prefecture
    )
  end

  # 屋内・屋外による絞り込み
  if params[:indoor].in?([ "true", "false" ])
    @dog_runs = @dog_runs.where(
      indoor: params[:indoor] == "true"
    )
  end
end

  def show
    @dog_run = DogRun.find(params[:id])
  end
end
