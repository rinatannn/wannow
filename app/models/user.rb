
class User < ApplicationRecord
  GUEST_EMAIL = "guest@wannow.example".freeze

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :dogs, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # グループへの参加情報
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # 自分が作成したグループ
  has_many :created_groups, class_name: "Group", foreign_key: :user_id, dependent: :nullify
  
  # 氏名を必須にする
  validates :name, presence: true

  # メールアドレスを必須にし、重複登録を防ぐ
  validates :email_address, presence: true, uniqueness: true

  # ゲストユーザーかどうか判定する
  def guest?
    email_address == GUEST_EMAIL
  end
end
