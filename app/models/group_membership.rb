class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: :group_id }
end
