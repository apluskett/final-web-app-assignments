require "test_helper"

class StudentTest < ActiveSupport::TestCase
  test "should not save student without required fields" do
    student = Student.new
    assert_not student.save
    
    assert_includes student.errors[:first_name], "can't be blank"
    assert_includes student.errors[:last_name], "can't be blank"
    assert_includes student.errors[:student_id], "can't be blank"
    assert_includes student.errors[:email], "can't be blank"
  end

  test "should save valid student" do
    student = Student.new(
      first_name: "Test",
      last_name: "User",
      student_id: "S999999999",
      email: "test.user@example.com"
    )
    assert student.save
  end

  test "should enforce uniqueness of student_id" do
    Student.create!(
      first_name: "John",
      last_name: "Test",
      student_id: "S888888888",
      email: "john.test@example.com"
    )
    
    duplicate_student = Student.new(
      first_name: "Jane",
      last_name: "Smith",
      student_id: "S888888888",
      email: "jane.smith@example.com"
    )
    
    assert_not duplicate_student.save
    assert_includes duplicate_student.errors[:student_id], "has already been taken"
  end

  test "should enforce uniqueness of email" do
    Student.create!(
      first_name: "John",
      last_name: "Unique",
      student_id: "S777777777",
      email: "unique@example.com"
    )
    
    duplicate_email_student = Student.new(
      first_name: "Jane",
      last_name: "Smith",
      student_id: "S666666666",
      email: "unique@example.com"
    )
    
    assert_not duplicate_email_student.save
    assert_includes duplicate_email_student.errors[:email], "has already been taken"
  end

  test "should validate email format" do
    student = Student.new(
      first_name: "Email",
      last_name: "Test",
      student_id: "S555555555",
      email: "invalid-email"
    )
    
    assert_not student.save
    assert_includes student.errors[:email], "is invalid"
    
    student.email = "valid.email@example.com"
    assert student.save
  end

  test "full_name should combine first and last name" do
    student = Student.new(first_name: "John", last_name: "Doe")
    assert_equal "John Doe", student.full_name
  end

  test "should have many sections through section_students" do
    student = students(:john_doe)
    assert_respond_to student, :sections
    assert_respond_to student, :section_students
    assert_kind_of ActiveRecord::Associations::CollectionProxy, student.sections
  end

  test "should be able to enroll in sections" do
    student = students(:john_doe)
    section = sections(:advanced_morning)  # john_doe is not enrolled in this one
    
    assert_difference('student.sections.count', 1) do
      student.sections << section
    end
  end

  test "should calculate total credit hours" do
    student = students(:john_doe)
    # Clear existing enrollments first
    student.sections.clear
    
    course1 = courses(:intro_programming) # 3 credit hours
    course2 = Course.create!(
      prefix: prefixes(:mathematics),
      number: "101",
      title: "Calculus I",
      credit_hours: 4
    )
    
    section1 = Section.create!(course: course1, name: "Test Section A")
    section2 = Section.create!(course: course2, name: "Test Section B")
    
    student.sections << [section1, section2]
    
    total_credits = student.sections.joins(:course).sum('courses.credit_hours')
    assert_equal 7, total_credits
  end

  test "destroying student should remove section enrollments" do
    student = students(:bob_johnson)  # Use a different student
    initial_count = student.section_students.count
    
    assert_difference('SectionStudent.count', -initial_count) do
      student.destroy!
    end
  end
end