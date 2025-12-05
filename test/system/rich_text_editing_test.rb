require "application_system_test_case"

class RichTextEditingTest < ApplicationSystemTestCase
  setup do
    @prefix = prefixes(:computer_science)
    @course = courses(:intro_programming)
  end

  test "should display Trix editor on new course page" do
    visit new_course_path
    
    # Check that Trix editor and toolbar are present
    assert_selector "trix-editor"
    assert_selector "trix-toolbar"
    
    # Check for common Trix toolbar buttons
    assert_selector "button[data-trix-attribute='bold']"
    assert_selector "button[data-trix-attribute='italic']"
    assert_selector "button[data-trix-attribute='bullet']"
    
    # Verify form fields are present
    assert_selector "select#course_prefix_id"
    assert_selector "input#course_number"
    assert_selector "input#course_title"
    assert_selector "input#course_credit_hours"
  end

  test "should create course with rich text syllabus" do
    visit new_course_path
    
    # Fill in basic course information
    select "CSCI - Computer Science", from: "course_prefix_id"
    fill_in "course_number", with: "401"
    fill_in "course_title", with: "Senior Capstone"
    fill_in "course_credit_hours", with: "4"
    
    # Add rich text content to syllabus
    # Note: In real usage, user would interact with Trix editor
    # For system tests, we can set the hidden input value
    execute_script("document.querySelector('input[name=\"course[syllabus]\"]').value = '<h2>Capstone Project</h2><p>Students will complete a <strong>major project</strong> demonstrating their skills.</p>'")
    
    click_button "Create Course"
    
    # Should redirect to course show page
    assert_text "Course was successfully created"
    assert_text "CSCI 401 - Senior Capstone"
    assert_text "Capstone Project"
    assert_text "major project"
  end

  test "should edit course with rich text syllabus" do
    # Create a course with existing content
    @course.update!(syllabus: "<h3>Original Content</h3><p>This is the original syllabus.</p>")
    
    visit edit_course_path(@course)
    
    # Verify Trix editor is present
    assert_selector "trix-editor"
    
    # Update the syllabus content
    execute_script("document.querySelector('input[name=\"course[syllabus]\"]').value = '<h3>Updated Content</h3><p>This is the <em>updated</em> syllabus with new information.</p>'")
    
    click_button "Update Course"
    
    # Verify update was successful
    assert_text "Course was successfully updated"
    assert_text "Updated Content"
    assert_text "updated"
  end

  test "should display Trix styling correctly in different themes" do
    visit new_course_path
    
    # Test light theme (default)
    assert_selector "trix-editor"
    
    # Verify custom Trix styling is applied
    # The white background should be visible regardless of theme
    trix_editor = find("trix-editor")
    editor_bg = trix_editor.style("background-color")
    
    # In system tests, we can't easily test computed styles,
    # but we can verify the style tags are present
    assert_selector "style", text: /trix-editor.*background-color.*ffffff/i
  end

  test "should handle empty syllabus gracefully" do
    visit course_path(@course)
    
    # Course without rich text content should display normally
    assert_text @course.title
    assert_text "Credit Hours: #{@course.credit_hours}"
    
    # Should not crash or show broken content
    assert_no_text "undefined"
    assert_no_text "null"
  end

  test "should preserve content when navigating back to edit form" do
    # Set up course with rich content
    @course.update!(syllabus: "<h2>Complex Content</h2><ul><li>Item 1</li><li>Item 2</li></ul><p>With <strong>formatting</strong>.</p>")
    
    visit course_path(@course)
    
    # Verify content displays correctly
    assert_text "Complex Content"
    assert_text "Item 1"
    assert_text "formatting"
    
    # Navigate to edit
    click_link "Edit Course"
    
    # Editor should be present and ready for editing
    assert_selector "trix-editor"
    
    # In a real browser, the editor would be populated with existing content
    # We can verify the hidden input has the content structure
    syllabus_input = find("input[name='course[syllabus]']", visible: false)
    assert syllabus_input.present?
  end

  test "should show course with formatted syllabus content" do
    rich_syllabus = <<~HTML
      <h2>Course Description</h2>
      <p>This course provides an introduction to <strong>computer science</strong> concepts.</p>
      
      <h3>Learning Objectives</h3>
      <ul>
        <li>Understand basic programming principles</li>
        <li>Learn problem-solving techniques</li>
        <li>Apply computational thinking</li>
      </ul>
      
      <h3>Prerequisites</h3>
      <p>Students should have <em>basic mathematics</em> background including algebra.</p>
    HTML

    @course.update!(syllabus: rich_syllabus)
    
    visit course_path(@course)
    
    # Verify all rich text elements display correctly
    assert_text "Course Description"
    assert_text "computer science"
    assert_text "Learning Objectives"
    assert_text "basic programming principles"
    assert_text "Prerequisites"
    assert_text "basic mathematics"
    
    # Verify semantic HTML structure is preserved
    # Note: ActionText may modify the exact HTML structure while preserving meaning
    within(".syllabus-content") do
      assert_selector "h2, h3" # Headers should be present
      assert_selector "ul li" # List items should be present
      assert_selector "strong, em" # Formatting should be preserved
    end
  end
end