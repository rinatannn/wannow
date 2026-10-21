require "test_helper"

class GroupMembershipsControllerTest < ActionDispatch::IntegrationTest
  test "ログインしたユーザーはグループに参加できる" do
    user = users(:one)
    group = groups(:two)

    # ログインする
    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }

    # グループに参加する
    assert_difference "GroupMembership.count", 1 do
      post group_group_membership_url(group)
    end

    # 参加情報が保存されたことを確認する
    assert GroupMembership.exists?(user: user, group: group)

    # グループ詳細画面に戻ることを確認する
    assert_redirected_to group_url(group)
  end

    test "同じグループに二重参加できない" do
    user = users(:one)
    group = groups(:one)

    # ログインする
    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }

    # すでに参加済みのグループにもう一度参加する
    assert_no_difference "GroupMembership.count" do
      post group_group_membership_url(group)
    end

    # グループ詳細画面に戻ることを確認する
    assert_redirected_to group_url(group)
  end

    test "ログインしたユーザーはグループから退会できる" do
    user = users(:one)
    group = groups(:one)

    # ログインする
    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }

    # グループから退会する
    assert_difference "GroupMembership.count", -1 do
      delete group_group_membership_url(group)
    end

    # 参加情報が削除されたことを確認する
    assert_not GroupMembership.exists?(user: user, group: group)

    # グループ詳細画面に戻ることを確認する
    assert_redirected_to group_url(group)
  end

    test "未ログインのユーザーはグループに参加できない" do
    group = groups(:two)

    # ログインせずに参加を試みる
    assert_no_difference "GroupMembership.count" do
      post group_group_membership_url(group)
    end

    # ログイン画面へ移動することを確認
    assert_redirected_to new_session_url
  end

    test "未ログインのユーザーはグループから退会できない" do
    group = groups(:one)

    # ログインせずに退会を試みる
    assert_no_difference "GroupMembership.count" do
      delete group_group_membership_url(group)
    end

    # ログイン画面へ移動することを確認
    assert_redirected_to new_session_url

    # 既存の参加情報が残っていることを確認
    assert GroupMembership.exists?(user: users(:one), group: group)
  end

    test "グループ作成者以外は参加申請を承認できない" do
    owner = users(:one)
    other_user = users(:two)

    group = Group.create!(
      name: "権限テスト用グループ",
      description: "承認権限を確認する",
      user: owner
    )

    membership = GroupMembership.create!(
      user: other_user,
      group: group,
      status: :pending
    )

    post session_url, params: {
      email_address: other_user.email_address,
      password: "password"
    }

    patch approve_group_group_membership_url(group, membership)

    assert_redirected_to group_url(group)
    assert_equal "承認する権限がありません", flash[:alert]
    assert membership.reload.pending?
  end

    test "グループ作成者以外は参加申請を拒否できない" do
    owner = users(:one)
    other_user = users(:two)

    group = Group.create!(
      name: "拒否権限テスト用グループ",
      description: "拒否権限を確認する",
      user: owner
    )

    membership = GroupMembership.create!(
      user: other_user,
      group: group,
      status: :pending
    )

    post session_url, params: {
      email_address: other_user.email_address,
      password: "password"
    }

    patch reject_group_group_membership_url(group, membership)

    assert_redirected_to group_url(group)
    assert_equal "拒否する権限がありません", flash[:alert]
    assert membership.reload.pending?
  end

    test "第三者は参加申請を承認できない" do
    owner = users(:one)
    applicant = users(:two)
    third_user = users(:three)

    group = Group.create!(
      name: "第三者権限テスト",
      description: "第三者による承認を禁止する",
      user: owner
    )

    membership = GroupMembership.create!(
      user: applicant,
      group: group,
      status: :pending
    )

    post session_url, params: {
      email_address: third_user.email_address,
      password: "password"
    }

    patch approve_group_group_membership_url(group, membership)

    assert_redirected_to group_url(group)
    assert_equal "承認する権限がありません", flash[:alert]
    assert membership.reload.pending?
  end

    test "第三者は参加申請を拒否できない" do
    owner = users(:one)
    applicant = users(:two)
    third_user = users(:three)

    group = Group.create!(
      name: "第三者拒否権限テスト",
      description: "第三者による拒否を禁止する",
      user: owner
    )

    membership = GroupMembership.create!(
      user: applicant,
      group: group,
      status: :pending
    )

    post session_url, params: {
      email_address: third_user.email_address,
      password: "password"
    }

    patch reject_group_group_membership_url(group, membership)

    assert_redirected_to group_url(group)
    assert_equal "拒否する権限がありません", flash[:alert]
    assert membership.reload.pending?
  end
end