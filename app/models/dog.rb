class Dog < ApplicationRecord
  belongs_to :user

  has_many :check_ins, dependent: :destroy

  validates :name, presence: true
  validates :breed, presence: true
  validates :personality, presence: true
end