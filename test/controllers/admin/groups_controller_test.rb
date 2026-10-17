
require "test_helper"

class Admin::GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @group = groups(:one)

    post session_url, params: {
      email_address: @admin.email_address,
      password: "password"
    }

    assert_response :redirect
  end

  test "should get index" do
    get admin_groups_url
    assert_response :success
  end

  test "should get show" do
    get admin_group_url(@group)
    assert_response :success
  end

  test "should get new" do
    get new_admin_group_url
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_group_url(@group)
    assert_response :success
  end

  test "should create group" do
    assert_difference("Group.count", 1) do
      post admin_groups_url, params: {
        group: {
          name: "中型犬グループ",
          description: "中型犬の飼い主向け"
        }
      }
    end

    assert_redirected_to admin_group_url(Group.last)
  end

  test "should update group" do
    patch admin_group_url(@group), params: {
      group: {
        name: "更新したグループ名",
        description: "更新した説明"
      }
    }

    assert_redirected_to admin_group_url(@group)
    assert_equal "更新したグループ名", @group.reload.name
  end

  test "should destroy group" do
    assert_difference("Group.count", -1) do
      delete admin_group_url(@group)
    end

    assert_redirected_to admin_groups_url
  end


  test "regular user cannot access admin groups" do
    delete session_url

    post session_url, params: {
      email_address: users(:two).email_address,
      password: "password"
    }

    get admin_groups_url

    assert_redirected_to root_url
  end
end
