class DogRun < ApplicationRecord
  # チェックインとの関連付け
  has_many :check_ins, dependent: :destroy

  # 来場予定との関連付け
  has_many :visit_plans, dependent: :destroy

  # 住所から緯度・経度を取得する設定
  geocoded_by :address

  # 保存前のバリデーション時に、必要であれば緯度・経度を自動取得
  before_validation :geocode, if: :should_geocode?

  # 必須項目のバリデーション
  validates :name, presence: true
  validates :address, presence: true
  validates :opening_time, presence: true
  validates :closing_time, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  # バリデーションエラーで表示する項目名を日本語にする
  def self.human_attribute_name(attribute, options = {})
    {
      "latitude" => "緯度",
      "longitude" => "経度"
    }.fetch(attribute.to_s) { super }
  end

  private

  # 住所から緯度・経度を自動取得する必要があるか判定
  def should_geocode?
    # 住所が変更され、緯度または経度が空欄の場合に自動取得
    will_save_change_to_address? &&
      (latitude.blank? || longitude.blank?)
  end
end