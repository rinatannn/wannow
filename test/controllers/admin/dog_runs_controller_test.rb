require "test_helper"

class Admin::DogRunsControllerTest < ActionDispatch::IntegrationTest
  # 管理者がドッグラン一覧画面にアクセスできることを確認
  test "管理者はドッグラン一覧画面にアクセスできる" do
    # 管理者としてログイン
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    # ドッグラン管理一覧画面にアクセス
    get admin_dog_runs_path

    # HTTPステータス200（正常）が返ることを確認
    assert_response :success
  end

  # 管理者がドッグラン詳細画面にアクセスできることを確認
  test "管理者はドッグラン詳細画面にアクセスできる" do
    # 管理者としてログイン
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    # テスト用ドッグランを取得
    dog_run = dog_runs(:one)

    # ドッグラン詳細画面にアクセス
    get admin_dog_run_path(dog_run)

    # 正常に画面が表示されることを確認
    assert_response :success
  end

  # 管理者がドッグラン新規登録画面にアクセスできることを確認
  test "管理者はドッグラン新規登録画面にアクセスできる" do
    # 管理者としてログイン
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    # 新規登録画面にアクセス
    get new_admin_dog_run_path

    # 正常に画面が表示されることを確認
    assert_response :success
  end

  # 管理者が新しいドッグランを登録できることを確認
  test "管理者はドッグランを新規登録できる" do
    # 管理者としてログイン
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    # 登録前後でドッグランの件数が1件増えることを確認
    assert_difference("DogRun.count", 1) do
      # 新しいドッグランを登録
      post admin_dog_runs_path, params: {
        dog_run: {
          name: "テストドッグラン",
          address: "福岡県久留米市",
          opening_time: "09:00",
          closing_time: "18:00",
          indoor: false,
          latitude: 33.3193,
          longitude: 130.5084
        }
      }
    end

    # 登録後、ドッグラン一覧画面に移動することを確認
    assert_redirected_to admin_dog_runs_path
  end

  # 管理者がドッグラン編集画面にアクセスできることを確認
  test "管理者はドッグラン編集画面にアクセスできる" do
    # 管理者としてログイン
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    # テスト用ドッグランを取得
    dog_run = dog_runs(:one)

    # 編集画面にアクセス
    get edit_admin_dog_run_path(dog_run)

    # 正常に画面が表示されることを確認
    assert_response :success
  end

  # 管理者がドッグラン情報を更新できることを確認
  test "管理者はドッグラン情報を更新できる" do
    # 管理者としてログイン
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    # テスト用ドッグランを取得
    dog_run = dog_runs(:one)

    # ドッグランの名前と住所を更新
    patch admin_dog_run_path(dog_run), params: {
      dog_run: {
        name: "更新後のドッグラン",
        address: "福岡県福岡市"
      }
    }

    # 更新後のデータをデータベースから再取得
    dog_run.reload

    # 名前と住所が正しく変更されたことを確認
    assert_equal "更新後のドッグラン", dog_run.name
    assert_equal "福岡県福岡市", dog_run.address

    # 更新後、詳細画面に移動することを確認
    assert_redirected_to admin_dog_run_path(dog_run)
  end

  # 管理者がドッグランを削除できることを確認
  test "管理者はドッグランを削除できる" do
    # 管理者としてログイン
    post session_path, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    # テスト用ドッグランを取得
    dog_run = dog_runs(:one)

    # 削除前後でドッグランの件数が1件減ることを確認
    assert_difference("DogRun.count", -1) do
      # ドッグランを削除
      delete admin_dog_run_path(dog_run)
    end

    # 削除後、一覧画面に移動することを確認
    assert_redirected_to admin_dog_runs_path
  end

  # 未ログインユーザーが管理画面にアクセスできないことを確認
  test "未ログインユーザーはドッグラン管理画面にアクセスできない" do
    # ログインせずに管理画面へアクセス
    get admin_dog_runs_path

    # ログイン画面へ移動することを確認
    assert_redirected_to new_session_path
  end

  # 一般ユーザーがドッグラン管理画面にアクセスできないことを確認
  test "一般ユーザーはドッグラン管理画面にアクセスできない" do
    # 一般ユーザーとしてログイン
    post session_path, params: {
      email_address: users(:two).email_address,
      password: "password"
    }

    # ドッグラン管理画面にアクセス
    get admin_dog_runs_path

    # トップページへ戻されることを確認
    assert_redirected_to root_path
  end

  # 一般ユーザーがドッグランを新規登録できないことを確認
  test "一般ユーザーはドッグランを新規登録できない" do
    # 一般ユーザーとしてログイン
    post session_path, params: {
      email_address: users(:two).email_address,
      password: "password"
    }

    # 登録件数が変わらないことを確認
    assert_no_difference("DogRun.count") do
      # 管理者用の登録処理に直接アクセス
      post admin_dog_runs_path, params: {
        dog_run: {
          name: "不正登録テスト",
          address: "福岡県久留米市",
          opening_time: "09:00",
          closing_time: "18:00",
          indoor: false,
          latitude: 33.3193,
          longitude: 130.5084
        }
      }
    end

    # トップページへ戻されることを確認
    assert_redirected_to root_path
  end

  # 一般ユーザーがドッグラン情報を更新できないことを確認
  test "一般ユーザーはドッグラン情報を更新できない" do
    # 一般ユーザーとしてログイン
    post session_path, params: {
      email_address: users(:two).email_address,
      password: "password"
    }

    # テスト用ドッグランを取得
    dog_run = dog_runs(:one)

    # 更新前の名前を保存
    original_name = dog_run.name

    # 管理者用の更新処理に直接アクセス
    patch admin_dog_run_path(dog_run), params: {
      dog_run: {
        name: "不正に変更されたドッグラン"
      }
    }

    # データベースから最新情報を取得
    dog_run.reload

    # 名前が変更されていないことを確認
    assert_equal original_name, dog_run.name

    # トップページへ戻されることを確認
    assert_redirected_to root_path
  end

  # 一般ユーザーがドッグランを削除できないことを確認
  test "一般ユーザーはドッグランを削除できない" do
    # 一般ユーザーとしてログイン
    post session_path, params: {
      email_address: users(:two).email_address,
      password: "password"
    }

    # テスト用ドッグランを取得
    dog_run = dog_runs(:one)

    # 削除前後でドッグランの件数が変わらないことを確認
    assert_no_difference("DogRun.count") do
      # 管理者用の削除処理に直接アクセス
      delete admin_dog_run_path(dog_run)
    end

    # 削除対象のドッグランが残っていることを確認
    assert DogRun.exists?(dog_run.id)

    # トップページへ戻されることを確認
    assert_redirected_to root_path
  end
end
