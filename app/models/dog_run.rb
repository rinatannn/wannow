class DogRun < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :opening_time, presence: true
  validates :closing_time, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
