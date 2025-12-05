require "test_helper"

class PrefixesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prefix = prefixes(:computer_science)
    @valid_attributes = {
      code: "BIO",
      description: "Biology"
    }
    @invalid_attributes = {
      code: "",
      description: ""
    }
  end

  test "should get index" do
    get prefixes_url
    assert_response :success
    assert_select "h1", "Course Prefixes"
    assert_select "a[href=?]", new_prefix_path
  end

  test "should get new" do
    get new_prefix_url
    assert_response :success
    assert_select "h1", "Create New Prefix"
    assert_select "form"
  end

  test "should create prefix with valid attributes" do
    assert_difference("Prefix.count") do
      post prefixes_url, params: { prefix: @valid_attributes }
    end

    prefix = Prefix.find_by(code: "MATH")
    assert_redirected_to prefixes_path
    assert_equal "Prefix was successfully created.", flash[:notice]
  end

  test "should not create prefix with invalid attributes" do
    assert_no_difference("Prefix.count") do
      post prefixes_url, params: { prefix: @invalid_attributes }
    end

    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Error message container
  end

  test "should get edit" do
    get edit_prefix_url(@prefix)
    assert_response :success
    assert_select "h1", /Edit Prefix: #{@prefix.code}/
    assert_select "form"
  end

  test "should update prefix with valid attributes" do
    patch prefix_url(@prefix), params: { prefix: { description: "Updated Description" } }
    assert_redirected_to prefixes_path
    assert_equal "Prefix was successfully updated.", flash[:notice]
    
    @prefix.reload
    assert_equal "Updated Description", @prefix.description
  end

  test "should not update prefix with invalid attributes" do
    patch prefix_url(@prefix), params: { prefix: @invalid_attributes }
    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Error message container
  end

  test "should destroy prefix without courses" do
    # Create a prefix without courses
    prefix_without_courses = Prefix.create!(code: "TEMP", description: "Temporary")
    
    assert_difference("Prefix.count", -1) do
      delete prefix_url(prefix_without_courses)
    end

    assert_redirected_to prefixes_path
    assert_equal "Prefix was successfully deleted.", flash[:notice]
  end

  test "should not destroy prefix with associated courses" do
    # @prefix has associated courses from fixtures
    assert_no_difference("Prefix.count") do
      delete prefix_url(@prefix)
    end

    assert_redirected_to prefixes_path
    assert_match /Cannot delete prefix.*courses/, flash[:alert]
  end

  test "should handle non-existent prefix" do
    get prefix_url(999999)
    assert_response :not_found
  end

  test "should convert code to uppercase in params" do
    post prefixes_url, params: { prefix: { code: "eng", description: "English Language" } }
    assert_response :redirect
    
    prefix = Prefix.find_by(description: "English Language")
    assert_not_nil prefix, "Prefix should have been created"
    assert_equal "ENG", prefix.code
  end
end