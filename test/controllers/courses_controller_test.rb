require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:intro_programming)
    @prefix = prefixes(:computer_science)
    @valid_attributes = {
      prefix_id: @prefix.id,
      number: "201",
      title: "Data Structures",
      credit_hours: 3,
      syllabus: "This course covers data structures and algorithms."
    }
    @invalid_attributes = {
      prefix_id: nil,
      number: "",
      title: "",
      credit_hours: nil
    }
  end

  test "should get index" do
    get courses_url
    assert_response :success
    assert_select "h1", "Courses"
    assert_select "a[href=?]", new_course_path
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
    assert_select "h1", /#{@course.prefix.code}\s+#{@course.number}\s+-\s+#{@course.title}/
  end

  test "should get new" do
    get new_course_url
    assert_response :success
    assert_select "h1", "Create New Course"
    assert_select "form"
    assert_select "select#course_prefix_id"
  end

  test "should create course with valid attributes" do
    assert_difference("Course.count") do
      post courses_url, params: { course: @valid_attributes }
    end

    course = Course.find_by(number: "201")
    assert_redirected_to course_path(course)
    assert_equal "Course was successfully created.", flash[:notice]
  end

  test "should not create course with invalid attributes" do
    assert_no_difference("Course.count") do
      post courses_url, params: { course: @invalid_attributes }
    end

    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Error message container
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
    assert_select "h1", /Edit Course: #{@course.prefix.code}\s+#{@course.number}/
    assert_select "form"
  end

  test "should update course with valid attributes" do
    patch course_url(@course), params: { course: { title: "Updated Title" } }
    assert_redirected_to course_path(@course)
    assert_equal "Course was successfully updated.", flash[:notice]
    
    @course.reload
    assert_equal "Updated Title", @course.title
  end

  test "should not update course with invalid attributes" do
    patch course_url(@course), params: { course: @invalid_attributes }
    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Error message container
  end

  test "should destroy course" do
    assert_difference("Course.count", -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_path
    assert_equal "Course was successfully deleted.", flash[:notice]
  end

  test "should handle JSON requests for index" do
    get courses_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_kind_of Array, json_response
    assert json_response.length > 0
  end

  test "should handle JSON requests for show" do
    get course_url(@course), as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal @course.title, json_response['title']
    assert_equal @course.number, json_response['number']
  end

  test "should handle JSON create request" do
    assert_difference("Course.count") do
      post courses_url, params: { course: @valid_attributes }, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal "201", json_response['number']
  end

  test "should handle non-existent course" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get course_url(999999)
    end
  end

  test "should display course sections on show page" do
    # Create a section for the course
    section = Section.create!(course: @course, name: "Test Section")
    
    get course_url(@course)
    assert_response :success
    assert_select "a[href=?]", section_path(section)
  end

  test "should filter courses by prefix" do
    get courses_url, params: { prefix: @prefix.code }
    assert_response :success
    # Should only show courses with that prefix
  end
end