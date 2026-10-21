class AddStatusToGroupMemberships < ActiveRecord::Migration[8.0]
  def up
    add_column :group_memberships, :status, :integer, default: 0, null: false

    # 既存の参加者は承認済みにする
    execute "UPDATE group_memberships SET status = 1"
  end

  def down
    remove_column :group_memberships, :status
  end
end