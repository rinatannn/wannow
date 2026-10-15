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
end
