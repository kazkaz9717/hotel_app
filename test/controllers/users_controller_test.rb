require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_new_url
    assert_response :success
  end

  test "should get create" do
    get users_create_url
    assert_response :success
  end

  test "should get show" do
    get users_show_url
    assert_response :success
  end

  test "should get edit" do
    get users_edit_url
    assert_response :success
  end

  test "should get update" do
    get users_update_url
    assert_response :success
  end

  test "should get account" do
    get users_account_url
    assert_response :success
  end

  test "should get edit_account" do
    get users_edit_account_url
    assert_response :success
  end

  test "should get update_account" do
    get users_update_account_url
    assert_response :success
  end
end
