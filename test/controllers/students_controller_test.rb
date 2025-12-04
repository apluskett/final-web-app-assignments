require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = students(:john_doe)
    @valid_attributes = {
      first_name: "Alice",
      last_name: "Johnson",
      student_id: "S123456789",
      email: "alice.johnson@example.com"
    }
    @invalid_attributes = {
      first_name: "",
      last_name: "",
      student_id: "",
      email: "invalid-email"
    }
  end

  test "should get index" do
    get students_url
    assert_response :success
    assert_select "h1", "Students"
    assert_select "a[href=?]", new_student_path
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
    assert_select "h1", "#{@student.first_name} #{@student.last_name}"
    assert_text @student.student_id
    assert_text @student.email
  end

  test "should get new" do
    get new_student_url
    assert_response :success
    assert_select "h1", "Create New Student"
    assert_select "form"
  end

  test "should create student with valid attributes" do
    assert_difference("Student.count") do
      post students_url, params: { student: @valid_attributes }
    end

    student = Student.find_by(student_id: "S123456789")
    assert_redirected_to student_path(student)
    assert_equal "Student was successfully created.", flash[:notice]
  end

  test "should not create student with invalid attributes" do
    assert_no_difference("Student.count") do
      post students_url, params: { student: @invalid_attributes }
    end

    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Error message container
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
    assert_select "h1", /Edit Student: #{@student.first_name}\s+#{@student.last_name}/
    assert_select "form"
  end

  test "should update student with valid attributes" do
    patch student_url(@student), params: { 
      student: { first_name: "Updated", email: "updated@example.com" } 
    }
    assert_redirected_to student_path(@student)
    assert_equal "Student was successfully updated.", flash[:notice]
    
    @student.reload
    assert_equal "Updated", @student.first_name
    assert_equal "updated@example.com", @student.email
  end

  test "should not update student with invalid attributes" do
    patch student_url(@student), params: { student: @invalid_attributes }
    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Error message container
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_path
    assert_equal "Student was successfully deleted.", flash[:notice]
  end

  test "should destroy student and remove section enrollments" do
    section = sections(:intro_morning)
    @student.sections << section
    assert_equal 1, @student.sections.count
    
    assert_difference("SectionStudent.count", -1) do
      assert_difference("Student.count", -1) do
        delete student_url(@student)
      end
    end
  end

  test "should handle JSON requests for index" do
    get students_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_kind_of Array, json_response
    assert json_response.length > 0
  end

  test "should handle JSON requests for show" do
    get student_url(@student), as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal @student.first_name, json_response['first_name']
    assert_equal @student.last_name, json_response['last_name']
    assert_equal @student.student_id, json_response['student_id']
    assert_equal @student.email, json_response['email']
  end

  test "should handle JSON create request" do
    assert_difference("Student.count") do
      post students_url, params: { student: @valid_attributes }, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal "Alice", json_response['first_name']
    assert_equal "S123456789", json_response['student_id']
  end

  test "should handle non-existent student" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get student_url(999999)
    end
  end

  test "should display student enrollments on show page" do
    section = sections(:intro_morning)
    @student.sections << section
    
    get student_url(@student)
    assert_response :success
    assert_select "a[href=?]", section_path(section)
    # Should show total credit hours
    assert_text "Total Credit Hours"
  end

  test "should show enrollment suggestions for unenrolled students" do
    # Create a student with no enrollments
    unenrolled_student = Student.create!(
      first_name: "Unenrolled",
      last_name: "Student", 
      student_id: "S000000000",
      email: "unenrolled@example.com"
    )
    
    get student_url(unenrolled_student)
    assert_response :success
    assert_text "not enrolled in any sections"
  end

  test "should validate uniqueness of student_id in create" do
    # Try to create student with existing student_id
    duplicate_attrs = @valid_attributes.dup
    duplicate_attrs[:student_id] = @student.student_id
    
    assert_no_difference("Student.count") do
      post students_url, params: { student: duplicate_attrs }
    end
    
    assert_response :unprocessable_entity
  end

  test "should validate uniqueness of email in create" do
    # Try to create student with existing email
    duplicate_attrs = @valid_attributes.dup
    duplicate_attrs[:email] = @student.email
    
    assert_no_difference("Student.count") do
      post students_url, params: { student: duplicate_attrs }
    end
    
    assert_response :unprocessable_entity
  end
end