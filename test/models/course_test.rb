require "test_helper"

class CourseTest < ActiveSupport::TestCase
  def setup
    @prefix = prefixes(:computer_science)
  end

  test "should not save course without required fields" do
    course = Course.new
    assert_not course.save
    
    assert_includes course.errors[:prefix], "must exist"
    assert_includes course.errors[:number], "can't be blank"
    assert_includes course.errors[:title], "can't be blank"
    assert_includes course.errors[:credit_hours], "can't be blank"
  end

  test "should save valid course" do
    course = Course.new(
      prefix: @prefix,
      number: "999",
      title: "Introduction to Programming",
      credit_hours: 3
    )
    assert course.save
  end

  test "should save course with rich text syllabus" do
    course = Course.new(
      prefix: @prefix,
      number: "998",
      title: "Advanced Programming",
      credit_hours: 4
    )
    course.syllabus = "<h2>Course Overview</h2><p>This course covers <strong>advanced programming concepts</strong>.</p>"
    assert course.save
    assert course.syllabus.present?
  end

  test "should handle empty syllabus" do
    course = Course.new(
      prefix: @prefix,
      number: "997",
      title: "Programming Basics",
      credit_hours: 2
    )
    assert course.save
    assert course.syllabus.blank?
  end

  test "should persist rich text syllabus" do
    course = Course.create!(
      prefix: @prefix,
      number: "996",
      title: "Web Development",
      credit_hours: 3,
      syllabus: "<h3>Learning Objectives</h3><ul><li>HTML/CSS</li><li>JavaScript</li></ul>"
    )
    
    saved_course = Course.find(course.id)
    assert_includes saved_course.syllabus.to_s, "Learning Objectives"
    assert_includes saved_course.syllabus.to_s, "HTML/CSS"
  end

  test "should enforce uniqueness of prefix and number combination" do
    Course.create!(prefix: @prefix, number: "995", title: "Intro 1", credit_hours: 3)
    
    duplicate_course = Course.new(
      prefix: @prefix,
      number: "995", 
      title: "Intro 2",
      credit_hours: 4
    )
    
    assert_not duplicate_course.save
    assert_includes duplicate_course.errors[:number], "has already been taken"
  end

  test "should allow same number for different prefixes" do
    math_prefix = Prefix.create!(code: "MTH", description: "Mathematics Two")
    
    Course.create!(prefix: @prefix, number: "994", title: "CS Intro", credit_hours: 3)
    duplicate_number_course = Course.new(
      prefix: math_prefix,
      number: "994",
      title: "Math Intro",
      credit_hours: 3
    )
    
    assert duplicate_number_course.save
  end

  test "should validate credit hours range" do
    course = Course.new(
      prefix: @prefix,
      number: "993",
      title: "Test Course",
      credit_hours: 0
    )
    
    assert_not course.save
    assert_includes course.errors[:credit_hours], "must be greater than 0"
    
    course.credit_hours = 7
    assert_not course.save
    assert_includes course.errors[:credit_hours], "must be less than or equal to 6"
    
    course.credit_hours = 3
    assert course.save
  end

  test "display_name should combine prefix code, number, and title" do
    course = Course.new(
      prefix: @prefix,
      number: "992",
      title: "Introduction to Programming",
      credit_hours: 3
    )
    
    expected = "CS 992 - Introduction to Programming"
    assert_equal expected, course.display_name
  end

  test "should belong to prefix" do
    course = courses(:intro_programming)
    assert_respond_to course, :prefix
    assert_kind_of Prefix, course.prefix
  end

  test "should have many sections" do
    course = courses(:intro_programming)
    assert_respond_to course, :sections
    assert_kind_of ActiveRecord::Associations::CollectionProxy, course.sections
  end

  test "destroying course should destroy associated sections" do
    course = courses(:intro_programming)
    initial_section_count = course.sections.count
    section = Section.create!(course: course, name: "Test Section 001")
    
    assert_difference('Section.count', -(initial_section_count + 1)) do
      course.destroy!
    end
  end
end