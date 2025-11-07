require "test_helper"

class OwnerdocControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ownerdoc_index_url
    assert_response :success
  end

  test "should get new" do
    get ownerdoc_new_url
    assert_response :success
  end

  test "should get create" do
    get ownerdoc_create_url
    assert_response :success
  end

  test "should get update" do
    get ownerdoc_update_url
    assert_response :success
  end

  test "should get destory" do
    get ownerdoc_destory_url
    assert_response :success
  end

  test "should get edit" do
    get ownerdoc_edit_url
    assert_response :success
  end

  test "should get show" do
    get ownerdoc_show_url
    assert_response :success
  end
end
