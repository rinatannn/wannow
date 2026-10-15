class Dog < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :breed, presence: true
  validates :personality, presence: true
end