require "test_helper"

class OfficeManagerTest < ActiveSupport::TestCase
  setup do
    @om = office_managers(:one)
  end

  test "fixture is valid" do
    assert @om.valid?
  end

  test "name presence" do
    @om.name = ""
    assert_not @om.valid?
    assert_includes @om.errors[:name], "can't be blank"
  end
end
require "test_helper"

class OfficeManagerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
