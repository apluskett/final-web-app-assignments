require "test_helper"

class PrefixTest < ActiveSupport::TestCase
  test "should not save prefix without code" do
    prefix = Prefix.new(description: "Computer Science")
    assert_not prefix.save
    assert_includes prefix.errors[:code], "can't be blank"
  end

  test "should not save prefix without description" do
    prefix = Prefix.new(code: "CS")
    assert_not prefix.save
    assert_includes prefix.errors[:description], "can't be blank"
  end

  test "should save valid prefix" do
    prefix = Prefix.new(code: "CS", description: "Computer Science")
    assert prefix.save
  end

  test "should enforce uniqueness of code" do
    Prefix.create!(code: "CS", description: "Computer Science")
    duplicate_prefix = Prefix.new(code: "CS", description: "Computer Studies")
    
    assert_not duplicate_prefix.save
    assert_includes duplicate_prefix.errors[:code], "has already been taken"
  end

  test "should convert code to uppercase" do
    prefix = Prefix.create!(code: "cs", description: "Computer Science")
    assert_equal "CS", prefix.code
  end

  test "should validate code format" do
    invalid_prefix = Prefix.new(code: "CS123", description: "Invalid")
    assert_not invalid_prefix.save
    assert_includes invalid_prefix.errors[:code], "must be 2-4 letters only"

    valid_prefix = Prefix.new(code: "MATH", description: "Mathematics")
    assert valid_prefix.save
  end

  test "display_name should combine code and description" do
    prefix = Prefix.new(code: "CS", description: "Computer Science")
    assert_equal "CS - Computer Science", prefix.display_name
  end

  test "should have many courses" do
    prefix = prefixes(:computer_science)
    assert_respond_to prefix, :courses
    assert_kind_of ActiveRecord::Associations::CollectionProxy, prefix.courses
  end

  test "destroying prefix with courses should raise error" do
    prefix = prefixes(:computer_science)
    Course.create!(prefix: prefix, number: "101", title: "Intro", credit_hours: 3)
    
    assert_raises ActiveRecord::DeleteRestrictionError do
      prefix.destroy!
    end
  end
end