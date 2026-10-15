class CheckIn < ApplicationRecord
  belongs_to :dog
  belongs_to :dog_run

  validates :checked_in_at, presence: true
  validate :one_active_check_in_per_dog

  private

  def one_active_check_in_per_dog
    return if dog_id.blank? || checked_out_at.present?

    if CheckIn.where(dog_id: dog_id, checked_out_at: nil).where.not(id: id).exists?
      errors.add(:dog, "はすでにチェックインしています")
    end
  end
end