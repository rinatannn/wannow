class VisitPlan < ApplicationRecord
  belongs_to :dog
  belongs_to :dog_run

  validates :planned_at, presence: true
  validate :planned_at_cannot_be_in_the_past

  private

  def planned_at_cannot_be_in_the_past
    return if planned_at.blank?

    if planned_at < Time.current
      errors.add(:planned_at, "は現在より未来の日時を指定してください")
    end
  end
end
