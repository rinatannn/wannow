class Admin::DogRunsController < Admin::BaseController

  # ドッグラン一覧画面
  def index
    # 登録されているドッグランを名前順に取得
    @dog_runs = DogRun.order(:name)
  end

    # ドッグラン詳細画面
  def show
    # URLのIDに対応するドッグランを取得
    @dog_run = DogRun.find(params[:id])
  end

    # ドッグラン編集画面
  def edit
    # URLのIDから編集対象のドッグランを取得
    @dog_run = DogRun.find(params[:id])
  end

    # ドッグラン更新処理
  def update
    # URLのIDから更新対象のドッグランを取得
    @dog_run = DogRun.find(params[:id])

    # フォームから送信された情報で更新
    if @dog_run.update(dog_run_params)
      # 更新成功時は詳細画面へ移動
      redirect_to admin_dog_run_path(@dog_run), notice: "ドッグランを更新しました。"
    else
      # 更新失敗時は編集画面を再表示
      render :edit, status: :unprocessable_entity
    end
  end

  # ドッグラン新規登録画面
  def new
    # 新規登録用の空のオブジェクトを作成
    @dog_run = DogRun.new
  end

  # ドッグラン新規登録処理
  def create
    # フォームから送信された情報でドッグランを作成
    @dog_run = DogRun.new(dog_run_params)

    # データベースへの保存に成功した場合
    if @dog_run.save
      # 管理者用ドッグラン一覧画面へ移動
      redirect_to admin_dog_runs_path, notice: "ドッグランを登録しました。"
    else
      # 保存に失敗した場合は新規登録画面を再表示
      render :new, status: :unprocessable_entity
    end
  end

    # ドッグラン削除処理
  def destroy
    # URLのIDから削除対象のドッグランを取得
    @dog_run = DogRun.find(params[:id])

    # ドッグランをデータベースから削除
    @dog_run.destroy!

    # 削除後は管理者用ドッグラン一覧画面へ移動
    redirect_to admin_dog_runs_path, notice: "ドッグランを削除しました。"
  end

  private

  # フォームから受け取るパラメーターを制限
  def dog_run_params
    params.require(:dog_run).permit(
      :name,          # ドッグラン名
      :address,       # 住所
      :opening_time,  # 開店時間
      :closing_time,  # 閉店時間
      :indoor,        # 屋内施設かどうか
      :latitude,      # 緯度
      :longitude      # 経度
    )
  end

end