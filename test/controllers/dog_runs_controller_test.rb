require "test_helper"

class DogRunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dog_run = DogRun.create!(
      name: "テストドッグラン",
      address: "福岡県テスト市1-2-3",
      opening_time: "09:00",
      closing_time: "18:00",
      indoor: false,
      latitude: 33.3193,
      longitude: 130.5084
    )
  end

  test "ドッグラン一覧を表示できる" do
    get dog_runs_url
    assert_response :success
  end

  test "ドッグラン詳細を表示できる" do
    get dog_run_url(@dog_run)
    assert_response :success
  end

  test "ドッグラン名で検索できる" do
    get dog_runs_url, params: { keyword: "テストドッグラン" }

    assert_response :success
    assert_select "h2 a", text: @dog_run.name
  end

  test "住所で検索できる" do
    get dog_runs_url, params: { keyword: "福岡県" }

    assert_response :success
    assert_select "h2 a", text: @dog_run.name
  end

  test "一致しないキーワードでは検索結果が表示されない" do
    get dog_runs_url, params: { keyword: "北海道" }

    assert_response :success
    assert_select "h2 a", text: @dog_run.name, count: 0
    assert_select "p", text: "検索条件に一致するドッグランが見つかりませんでした。"
  end

  test "都道府県で絞り込みできる" do
  get dog_runs_url, params: { prefecture: "福岡県" }

  assert_response :success
  assert_select "h2 a", text: @dog_run.name

  get dog_runs_url, params: { prefecture: "佐賀県" }

  assert_response :success
  assert_select "h2 a", text: @dog_run.name, count: 0
  assert_select "p", text: "検索条件に一致するドッグランが見つかりませんでした。"
end

test "屋内・屋外で絞り込みできる" do
  # 登録済みのドッグランは屋外（indoor: false）
  get dog_runs_url, params: { indoor: "false" }

  assert_response :success
  assert_select "h2 a", text: @dog_run.name

  # 屋内を指定すると表示されない
  get dog_runs_url, params: { indoor: "true" }

  assert_response :success
  assert_select "h2 a", text: @dog_run.name, count: 0
  assert_select "p", text: "検索条件に一致するドッグランが見つかりませんでした。"
end

test "複数の条件を組み合わせて絞り込みできる" do
  get dog_runs_url, params: {
    keyword: "テスト",
    prefecture: "福岡県",
    indoor: "false"
  }

  assert_response :success
  assert_select "h2 a", text: @dog_run.name

  get dog_runs_url, params: {
    keyword: "テスト",
    prefecture: "福岡県",
    indoor: "true"
  }

  assert_response :success
  assert_select "h2 a", text: @dog_run.name, count: 0
  assert_select "p", text: "検索条件に一致するドッグランが見つかりませんでした。"
end
end
