require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get demos" do
    get pages_demos_url
    assert_response :success
  end

  test "should get f1_predictions" do
    get pages_f1_predictions_url
    assert_response :success
  end
end
