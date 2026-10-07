class ChangeSessionsUserIdToBigint < ActiveRecord::Migration[8.0]
  def up
    change_column :sessions, :user_id, :bigint, null: false
  end

  def down
    change_column :sessions, :user_id, :integer, null: false
  end
end