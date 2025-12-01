require "test_helper"

class AssignmentTest < ActiveSupport::TestCase
  setup do
    @assignment = assignments(:alice_website)
  end

  test "fixture is valid" do
    assert @assignment.valid?
  end

  test "prevents duplicate assignment" do
    dup = Assignment.new(employee: @assignment.employee, project: @assignment.project)
    assert_not dup.valid?
    assert_includes dup.errors[:project_id], "has already been taken"
  end
end
