require "test_helper"

class OfficeTest < ActiveSupport::TestCase
  setup do
    @office = offices(:one)
  end

  test "fixture is valid" do
    assert @office.valid?
  end

  test "number presence and numericality" do
    o = @office.dup
    o.number = nil
    assert_not o.valid?
    assert_includes o.errors[:number], "can't be blank"

    o.number = "abc"
    assert_not o.valid?
    assert_includes o.errors[:number], "is not a number"
  end
end
require "test_helper"

class OfficeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
