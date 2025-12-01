require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  setup do
    @employee = employees(:alice)
  end

  test "fixture is valid" do
    assert @employee.valid?
  end

  test "name presence" do
    e = @employee.dup
    e.name = ""
    assert_not e.valid?
    assert_includes e.errors[:name], "can't be blank"
  end

  test "search finds by name" do
    results = Employee.search(@employee.name)
    assert_includes results.map(&:id), @employee.id
  end
end
