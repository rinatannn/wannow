class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :dogs, dependent: :destroy
  has_many :posts, dependent: :destroy

  # グループへの参加情報
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # 氏名を必須にする
  validates :name, presence: true

  # メールアドレスを必須にし、重複登録を防ぐ
  validates :email_address, presence: true, uniqueness: true
end
