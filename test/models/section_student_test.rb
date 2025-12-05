require "test_helper"

class SectionStudentTest < ActiveSupport::TestCase
  test "should create section student relationship" do
    section = sections(:calculus_section_b)
    student = students(:john_doe)  # john_doe is not enrolled in calculus_section_b
    
    section_student = SectionStudent.new(section: section, student: student)
    assert section_student.save
  end

  test "should enforce uniqueness of section and student combination" do
    section = sections(:calculus_section_b)
    student = students(:john_doe)
    
    # Create first relationship
    SectionStudent.create!(section: section, student: student)
    
    # Attempt to create duplicate
    duplicate = SectionStudent.new(section: section, student: student)
    assert_not duplicate.save
    assert_includes duplicate.errors[:section_id], "has already been taken"
  end

  test "should belong to section and student" do
    section_student = SectionStudent.new(
      section: sections(:calculus_section_b),
      student: students(:bob_johnson)
    )
    
    assert_respond_to section_student, :section
    assert_respond_to section_student, :student
  end

  test "should require both section and student" do
    section_student = SectionStudent.new
    assert_not section_student.save
    
    assert_includes section_student.errors[:section], "must exist"
    assert_includes section_student.errors[:student], "must exist"
  end

  test "should allow same student in different sections" do
    student = students(:john_doe)
    # john_doe is already in intro_morning from fixtures
    section2 = Section.create!(
      course: courses(:advanced_programming),
      name: "Test Evening Section"
    )
    
    second_enrollment = SectionStudent.new(section: section2, student: student)
    assert second_enrollment.save
  end

  test "should allow same section with different students" do
    section = sections(:calculus_section_b)
    student1 = students(:john_doe)
    student2 = students(:jane_smith)
    
    SectionStudent.create!(section: section, student: student1)
    
    second_enrollment = SectionStudent.new(section: section, student: student2)
    assert second_enrollment.save
  end
end