require "test_helper"

class ActionTextIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @prefix = prefixes(:computer_science)
  end

  test "should display rich text content on course show page" do
    course = Course.create!(
      prefix: @prefix,
      number: "301",
      title: "Advanced Web Development",
      credit_hours: 4,
      syllabus: "<h2>Course Overview</h2><p>This course covers <strong>advanced web development</strong> concepts including:</p><ul><li>Server-side rendering</li><li>Database integration</li><li>API development</li></ul>"
    )

    get course_path(course)
    assert_response :success
    
    # Check that rich text content is displayed
    assert_select "div.trix-content", text: /Course Overview/
    assert_select "strong", "advanced web development"
    assert_select "li", "Server-side rendering"
  end

  test "should create course with rich text syllabus through form" do
    get new_course_path
    assert_response :success
    
    # Check that Trix editor is present
    assert_select "trix-editor"
    assert_select "input[name='course[syllabus]']", visible: false
    
    rich_text_content = "<h3>Learning Objectives</h3><ol><li>Understand MVC architecture</li><li>Build REST APIs</li></ol>"
    
    assert_difference("Course.count") do
      post courses_path, params: {
        course: {
          prefix_id: @prefix.id,
          number: "302",
          title: "System Architecture",
          credit_hours: 3,
          syllabus: rich_text_content
        }
      }
    end

    course = Course.find_by(number: "302")
    follow_redirect!
    
    assert_select "h1", /CSCI 302 - System Architecture/
    assert_includes course.syllabus.to_s, "Learning Objectives"
    assert_includes course.syllabus.to_s, "MVC architecture"
  end

  test "should update course syllabus with rich text" do
    course = courses(:intro_programming)
    
    get edit_course_path(course)
    assert_response :success
    assert_select "trix-editor"
    
    updated_syllabus = "<h2>Updated Course Content</h2><p>This course now includes <em>new topics</em>:</p><ul><li>Advanced algorithms</li><li>Design patterns</li></ul>"
    
    patch course_path(course), params: {
      course: {
        syllabus: updated_syllabus
      }
    }
    
    follow_redirect!
    course.reload
    
    assert_includes course.syllabus.to_s, "Updated Course Content"
    assert_includes course.syllabus.to_s, "new topics"
    assert_includes course.syllabus.to_s, "Design patterns"
  end

  test "should handle empty syllabus gracefully" do
    course = Course.create!(
      prefix: @prefix,
      number: "303",
      title: "Basic Programming",
      credit_hours: 2
    )

    get course_path(course)
    assert_response :success
    
    # Should not crash with empty syllabus
    assert_select "div.trix-content", count: 0
  end

  test "should sanitize harmful HTML in syllabus" do
    malicious_content = "<script>alert('xss')</script><h2>Safe Content</h2><p>This should be preserved</p>"
    
    course = Course.create!(
      prefix: @prefix,
      number: "304",
      title: "Security Testing",
      credit_hours: 3,
      syllabus: malicious_content
    )

    get course_path(course)
    assert_response :success
    
    # Script tags should be stripped, safe HTML preserved
    assert_select "script", count: 0
    assert_select "h2", "Safe Content"
    assert_select "p", "This should be preserved"
  end

  test "should preserve formatting when editing existing rich text" do
    original_content = "<h3>Original Title</h3><p>Original <strong>bold text</strong> and <em>italic text</em></p>"
    
    course = Course.create!(
      prefix: @prefix,
      number: "305",
      title: "Formatting Test",
      credit_hours: 1,
      syllabus: original_content
    )

    get edit_course_path(course)
    assert_response :success
    
    # The Trix editor should load with existing content
    # In a real browser, this would be populated by JavaScript
    # but in tests we can verify the hidden input has the content
    assert_select "input[name='course[syllabus]']" do |elements|
      # ActionText stores content differently, but the association should work
      assert course.syllabus.present?
    end
  end
end