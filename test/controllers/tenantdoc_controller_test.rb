require "test_helper"

class TenantdocControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tenantdoc_index_url
    assert_response :success
  end

  test "should get new" do
    get tenantdoc_new_url
    assert_response :success
  end

  test "should get create" do
    get tenantdoc_create_url
    assert_response :success
  end

  test "should get update" do
    get tenantdoc_update_url
    assert_response :success
  end

  test "should get destory" do
    get tenantdoc_destory_url
    assert_response :success
  end

  test "should get edit" do
    get tenantdoc_edit_url
    assert_response :success
  end

  test "should get show" do
    get tenantdoc_show_url
    assert_response :success
  end
end
