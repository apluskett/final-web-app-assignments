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
      first_name: "John",
      last_name: "Doe",
      student_id: "S001234567",
      email: "john.doe@example.com"
    )
    assert student.save
  end

  test "should enforce uniqueness of student_id" do
    Student.create!(
      first_name: "John",
      last_name: "Doe",
      student_id: "S001234567",
      email: "john@example.com"
    )
    
    duplicate_student = Student.new(
      first_name: "Jane",
      last_name: "Smith",
      student_id: "S001234567",
      email: "jane@example.com"
    )
    
    assert_not duplicate_student.save
    assert_includes duplicate_student.errors[:student_id], "has already been taken"
  end

  test "should enforce uniqueness of email" do
    Student.create!(
      first_name: "John",
      last_name: "Doe",
      student_id: "S001234567",
      email: "john@example.com"
    )
    
    duplicate_email_student = Student.new(
      first_name: "Jane",
      last_name: "Smith",
      student_id: "S987654321",
      email: "john@example.com"
    )
    
    assert_not duplicate_email_student.save
    assert_includes duplicate_email_student.errors[:email], "has already been taken"
  end

  test "should validate email format" do
    student = Student.new(
      first_name: "John",
      last_name: "Doe",
      student_id: "S001234567",
      email: "invalid-email"
    )
    
    assert_not student.save
    assert_includes student.errors[:email], "is invalid"
    
    student.email = "valid@example.com"
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
    section = sections(:intro_morning)
    
    assert_difference('student.sections.count', 1) do
      student.sections << section
    end
  end

  test "should calculate total credit hours" do
    student = students(:john_doe)
    course1 = courses(:intro_programming) # 3 credit hours
    course2 = Course.create!(
      prefix: prefixes(:mathematics),
      number: "101",
      title: "Calculus I",
      credit_hours: 4
    )
    
    section1 = Section.create!(course: course1, name: "Section A")
    section2 = Section.create!(course: course2, name: "Section B")
    
    student.sections << [section1, section2]
    
    total_credits = student.sections.joins(:course).sum('courses.credit_hours')
    assert_equal 7, total_credits
  end

  test "destroying student should remove section enrollments" do
    student = students(:john_doe)
    section = sections(:intro_morning)
    student.sections << section
    
    assert_difference('SectionStudent.count', -1) do
      student.destroy!
    end
  end
end