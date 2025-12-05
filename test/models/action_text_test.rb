require "test_helper"

class ActionTextMigrationTest < ActiveSupport::TestCase
  test "action_text_rich_texts table should exist" do
    assert ActiveRecord::Base.connection.table_exists?("action_text_rich_texts"), 
           "ActionText rich_texts table should exist after migrations"
  end

  test "active_storage_blobs table should exist" do
    assert ActiveRecord::Base.connection.table_exists?("active_storage_blobs"),
           "ActiveStorage blobs table should exist for ActionText file attachments"
  end

  test "active_storage_attachments table should exist" do
    assert ActiveRecord::Base.connection.table_exists?("active_storage_attachments"),
           "ActiveStorage attachments table should exist for ActionText file attachments"
  end

  test "action_text_rich_texts should have correct columns" do
    columns = ActiveRecord::Base.connection.columns("action_text_rich_texts").map(&:name)
    
    expected_columns = %w[id name body record_type record_id created_at updated_at]
    expected_columns.each do |column|
      assert_includes columns, column, "action_text_rich_texts should have #{column} column"
    end
  end

  test "action_text_rich_texts should have unique index" do
    indexes = ActiveRecord::Base.connection.indexes("action_text_rich_texts")
    unique_index = indexes.find { |index| index.unique && index.columns.sort == ["record_type", "record_id", "name"].sort }
    
    assert unique_index, "action_text_rich_texts should have unique index on [record_type, record_id, name]"
  end

  test "Course model should have ActionText association" do
    course = Course.new
    assert_respond_to course, :syllabus, "Course should respond to syllabus method"
    assert_respond_to course, :syllabus=, "Course should respond to syllabus= method"
    
    # Check that the association is properly configured
    association = Course.reflect_on_association(:rich_text_syllabus)
    assert association, "Course should have rich_text_syllabus association"
    assert_equal "ActionText::RichText", association.class_name
  end

  test "ActionText should handle polymorphic associations correctly" do
    course = courses(:intro_programming)
    
    # Assign rich text content
    course.syllabus = "<h2>Test Content</h2><p>This is a test.</p>"
    course.save!
    
    # Verify the ActionText record was created
    rich_text = ActionText::RichText.find_by(
      record_type: "Course",
      record_id: course.id,
      name: "syllabus"
    )
    
    assert rich_text, "ActionText record should be created for course syllabus"
    assert_includes rich_text.body.to_s, "Test Content"
  end

  test "ActionText should clean up when course is destroyed" do
    course = Course.create!(
      prefix: prefixes(:computer_science),
      number: "999",
      title: "Test Course",
      credit_hours: 1,
      syllabus: "<h2>Test Syllabus</h2><p>This will be deleted.</p>"
    )
    
    # Verify ActionText record exists
    rich_text_id = course.rich_text_syllabus.id
    assert ActionText::RichText.exists?(rich_text_id)
    
    # Destroy the course
    course.destroy!
    
    # ActionText record should be cleaned up automatically
    assert_not ActionText::RichText.exists?(rich_text_id),
               "ActionText record should be deleted when course is destroyed"
  end

  test "should handle course syllabus serialization correctly" do
    course = courses(:intro_programming)
    original_content = "<h2>Serialization Test</h2><p>Testing <strong>bold</strong> and <em>italic</em> text.</p>"
    
    course.update!(syllabus: original_content)
    course.reload
    
    # Test that content is preserved
    syllabus_content = course.syllabus.to_s
    assert_includes syllabus_content, "Serialization Test"
    assert_includes syllabus_content, "bold"
    assert_includes syllabus_content, "italic"
    
    # Test JSON serialization
    json_data = course.as_json(include: :syllabus)
    assert json_data["syllabus"]
  end
end