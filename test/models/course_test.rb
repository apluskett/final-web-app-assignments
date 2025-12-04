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
      number: "101",
      title: "Introduction to Programming",
      credit_hours: 3
    )
    assert course.save
  end

  test "should enforce uniqueness of prefix and number combination" do
    Course.create!(prefix: @prefix, number: "101", title: "Intro 1", credit_hours: 3)
    
    duplicate_course = Course.new(
      prefix: @prefix,
      number: "101", 
      title: "Intro 2",
      credit_hours: 4
    )
    
    assert_not duplicate_course.save
    assert_includes duplicate_course.errors[:number], "has already been taken"
  end

  test "should allow same number for different prefixes" do
    math_prefix = Prefix.create!(code: "MATH", description: "Mathematics")
    
    Course.create!(prefix: @prefix, number: "101", title: "CS Intro", credit_hours: 3)
    duplicate_number_course = Course.new(
      prefix: math_prefix,
      number: "101",
      title: "Math Intro",
      credit_hours: 3
    )
    
    assert duplicate_number_course.save
  end

  test "should validate credit hours range" do
    course = Course.new(
      prefix: @prefix,
      number: "101",
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
      number: "101",
      title: "Introduction to Programming",
      credit_hours: 3
    )
    
    expected = "CS 101 - Introduction to Programming"
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
    section = Section.create!(course: course, name: "Section 001")
    
    assert_difference('Section.count', -1) do
      course.destroy!
    end
  end
end