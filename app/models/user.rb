class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # 氏名を必須にする
  validates :name, presence: true

  # メールアドレスを必須にし、重複登録を防ぐ
  validates :email_address, presence: true, uniqueness: true
end
