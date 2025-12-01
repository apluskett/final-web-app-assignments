require "test_helper"

class OfficeManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @office_manager = office_managers(:one)
  end

  test "should get index" do
    get office_managers_url
    assert_response :success
  end

  test "should get new" do
    get new_office_manager_url
    assert_response :success
  end

  test "should create office_manager" do
    assert_difference("OfficeManager.count") do
      post office_managers_url, params: { office_manager: { name: @office_manager.name } }
    end

    assert_redirected_to office_manager_url(OfficeManager.last)
  end

  test "should show office_manager" do
    get office_manager_url(@office_manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_office_manager_url(@office_manager)
    assert_response :success
  end

  test "should update office_manager" do
    patch office_manager_url(@office_manager), params: { office_manager: { name: @office_manager.name } }
    assert_redirected_to office_manager_url(@office_manager)
  end

  test "should destroy office_manager" do
    assert_difference("OfficeManager.count", -1) do
      delete office_manager_url(@office_manager)
    end

    assert_redirected_to office_managers_url
  end
end
