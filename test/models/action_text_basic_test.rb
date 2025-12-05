require "test_helper"

class ActionTextBasicTest < ActiveSupport::TestCase
  # Don't use fixtures for this test
  fixtures :none
  
  test "course should accept rich text syllabus" do
    prefix = Prefix.create!(code: "CS", description: "Computer Science")
    course = Course.new(
      prefix: prefix,
      number: 101,
      title: "Introduction to Computer Science",
      credit_hours: 3
    )
    
    course.syllabus = "<p>This course covers <strong>basic programming concepts</strong>.</p>"
    
    assert course.valid?
    assert course.save
    assert_equal "<p>This course covers <strong>basic programming concepts</strong>.</p>", course.syllabus.to_s
  end
  
  test "course should store rich text content in action text table" do
    prefix = Prefix.create!(code: "MATH", description: "Mathematics")
    course = Course.create!(
      prefix: prefix,
      number: 200,
      title: "Calculus I",
      credit_hours: 4,
      syllabus: "<h1>Calculus I</h1><p>Study of <em>limits</em> and derivatives.</p>"
    )
    
    assert course.syllabus.present?
    assert course.syllabus.body.present?
    assert_includes course.syllabus.to_s, "Calculus I"
    assert_includes course.syllabus.to_s, "limits"
    assert_includes course.syllabus.to_s, "derivatives"
  end
end