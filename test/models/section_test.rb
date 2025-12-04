require "test_helper"

class SectionTest < ActiveSupport::TestCase
  def setup
    @course = courses(:intro_programming)
  end

  test "should not save section without required fields" do
    section = Section.new
    assert_not section.save
    
    assert_includes section.errors[:course], "must exist"
    assert_includes section.errors[:name], "can't be blank"
  end

  test "should save valid section" do
    section = Section.new(course: @course, name: "Section 001")
    assert section.save
  end

  test "should enforce uniqueness of name within course" do
    Section.create!(course: @course, name: "Section 001")
    
    duplicate_section = Section.new(course: @course, name: "Section 001")
    assert_not duplicate_section.save
    assert_includes duplicate_section.errors[:name], "has already been taken"
  end

  test "should allow same name for different courses" do
    other_course = Course.create!(
      prefix: prefixes(:mathematics),
      number: "101",
      title: "Calculus I",
      credit_hours: 4
    )
    
    Section.create!(course: @course, name: "Section 001")
    same_name_section = Section.new(course: other_course, name: "Section 001")
    
    assert same_name_section.save
  end

  test "should belong to course" do
    section = sections(:intro_morning)
    assert_respond_to section, :course
    assert_kind_of Course, section.course
  end

  test "should have many students through section_students" do
    section = sections(:intro_morning)
    assert_respond_to section, :students
    assert_respond_to section, :section_students
    assert_kind_of ActiveRecord::Associations::CollectionProxy, section.students
  end

  test "should be able to enroll students" do
    section = sections(:intro_morning)
    student = students(:john_doe)
    
    assert_difference('section.students.count', 1) do
      section.students << student
    end
  end

  test "should prevent duplicate student enrollment in same section" do
    section = sections(:intro_morning)
    student = students(:john_doe)
    
    section.students << student
    
    # Attempting to add same student again should not increase count
    assert_no_difference('section.students.count') do
      begin
        section.students << student
      rescue ActiveRecord::RecordInvalid
        # Expected behavior - uniqueness validation should prevent this
      end
    end
  end

  test "destroying section should remove student enrollments" do
    section = sections(:intro_morning)
    student = students(:john_doe)
    section.students << student
    
    assert_difference('SectionStudent.count', -1) do
      section.destroy!
    end
  end
end