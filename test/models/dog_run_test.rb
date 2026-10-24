require "test_helper"

class DogRunTest < ActiveSupport::TestCase
  setup do
    @dog_run = DogRun.new(
      name: "テストドッグラン",
      address: "福岡県テスト市1-2-3",
      opening_time: "09:00",
      closing_time: "18:00",
      indoor: false,
      latitude: 33.3193,
      longitude: 130.5084
    )
  end

  test "ドッグラン名が空欄の場合は保存できない" do
    @dog_run.name = nil
    assert_not @dog_run.valid?
  end

  test "住所が空欄の場合は保存できない" do
    @dog_run.address = nil
    assert_not @dog_run.valid?
  end

  test "営業時間が空欄の場合は保存できない" do
    @dog_run.opening_time = nil
    assert_not @dog_run.valid?
  end

  test "正しい情報なら有効である" do
    assert @dog_run.valid?
  end

  test "住所から緯度と経度を自動取得できる" do
    Geocoder.configure(lookup: :test)

    Geocoder::Lookup::Test.add_stub(
      "福岡県テスト市1-2-3",
      [
        {
          "latitude" => 33.5902,
          "longitude" => 130.4017
        }
      ]
    )

    @dog_run.latitude = nil
    @dog_run.longitude = nil

    assert @dog_run.valid?
    assert_equal 33.5902, @dog_run.latitude
    assert_equal 130.4017, @dog_run.longitude
  ensure
    Geocoder.configure(lookup: :nominatim)
    Geocoder::Lookup::Test.reset
  end
end
