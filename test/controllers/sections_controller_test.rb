require "test_helper"

class SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @section = sections(:intro_morning)
    @course = courses(:intro_programming)
    @student = students(:john_doe)
    @valid_attributes = {
      course_id: @course.id,
      name: "Section 002"
    }
    @invalid_attributes = {
      course_id: nil,
      name: ""
    }
  end

  test "should get index" do
    get sections_url
    assert_response :success
    assert_select "h1", "Course Sections"
    assert_select "a[href=?]", new_section_path
  end

  test "should show section" do
    get section_url(@section)
    assert_response :success
    assert_select "h1", /#{@section.course.prefix.code}\s+#{@section.course.number}\s+-\s+#{@section.name}/
  end

  test "should get new" do
    get new_section_url
    assert_response :success
    assert_select "h1", "Create New Section"
    assert_select "form"
    assert_select "select#section_course_id"
  end

  test "should create section with valid attributes" do
    assert_difference("Section.count") do
      post sections_url, params: { section: @valid_attributes }
    end

    section = Section.find_by(name: "Section 002")
    assert_redirected_to section_path(section)
    assert_equal "Section was successfully created.", flash[:notice]
  end

  test "should create section with student enrollments" do
    student_ids = [students(:john_doe).id, students(:jane_smith).id]
    section_params = @valid_attributes.merge(student_ids: student_ids)
    
    assert_difference("Section.count") do
      assert_difference("SectionStudent.count", 2) do
        post sections_url, params: { section: section_params }
      end
    end

    section = Section.find_by(name: "Section 002")
    assert_equal 2, section.students.count
  end

  test "should not create section with invalid attributes" do
    assert_no_difference("Section.count") do
      post sections_url, params: { section: @invalid_attributes }
    end

    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Error message container
  end

  test "should get edit" do
    get edit_section_url(@section)
    assert_response :success
    assert_select "h1", /Edit Section: #{@section.course.prefix.code}\s+#{@section.course.number}\s+-\s+#{@section.name}/
    assert_select "form"
  end

  test "should update section with valid attributes" do
    patch section_url(@section), params: { section: { name: "Updated Section Name" } }
    assert_redirected_to section_path(@section)
    assert_equal "Section was successfully updated.", flash[:notice]
    
    @section.reload
    assert_equal "Updated Section Name", @section.name
  end

  test "should update section student enrollments" do
    # Use a section without students enrolled
    empty_section = sections(:intro_evening)
    assert_equal 0, empty_section.students.count
    
    # Add students
    student_ids = [students(:john_doe).id, students(:jane_smith).id]
    patch section_url(empty_section), params: { 
      section: { name: empty_section.name, student_ids: student_ids }
    }
    
    empty_section.reload
    assert_equal 2, empty_section.students.count
    
    # Remove one student
    patch section_url(@section), params: { 
      section: { name: @section.name, student_ids: [students(:john_doe).id] }
    }
    
    @section.reload
    assert_equal 1, @section.students.count
    assert_includes @section.students, students(:john_doe)
  end

  test "should clear all student enrollments when none selected" do
    # First enroll some students
    @section.students = [students(:john_doe), students(:jane_smith)]
    assert_equal 2, @section.students.count
    
    # Update without any student_ids
    patch section_url(@section), params: { 
      section: { name: @section.name }
    }
    
    @section.reload
    assert_equal 0, @section.students.count
  end

  test "should not update section with invalid attributes" do
    patch section_url(@section), params: { section: @invalid_attributes }
    assert_response :unprocessable_entity
    assert_select ".bg-red-50" # Error message container
  end

  test "should destroy section" do
    assert_difference("Section.count", -1) do
      delete section_url(@section)
    end

    assert_redirected_to sections_path
    assert_equal "Section was successfully deleted.", flash[:notice]
  end

  test "should destroy section and remove student enrollments" do
    # @section may already have enrollments from fixtures
    initial_enrollment_count = @section.section_students.count
    
    assert_difference("SectionStudent.count", -initial_enrollment_count) do
      assert_difference("Section.count", -1) do
        delete section_url(@section)
      end
    end
  end

  test "should handle JSON requests" do
    get sections_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_kind_of Array, json_response
  end

  test "should handle non-existent section" do
    get section_url(999999)
    assert_response :not_found
  end

  test "should show available students on section detail page" do
    # Ensure there's an available student not enrolled
    available_student = Student.create!(
      first_name: "Available",
      last_name: "Student",
      student_id: "S999999999",
      email: "available@example.com"
    )
    
    get section_url(@section)
    assert_response :success
    # Should display available students count/information
  end

  test "should pre-select course when creating section with course_id param" do
    get new_section_url, params: { course_id: @course.id }
    assert_response :success
    assert_select "option[value='#{@course.id}'][selected]"
  end
end