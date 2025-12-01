require "application_system_test_case"

class OfficeManagersTest < ApplicationSystemTestCase
  setup do
    @office_manager = office_managers(:one)
  end

  test "visiting the index" do
    visit office_managers_url
    assert_selector "h1", text: "Office managers"
  end

  test "should create office manager" do
    visit office_managers_url
    click_on "New office manager"

    fill_in "Name", with: @office_manager.name
    click_on "Create Office manager"

    assert_text "Office manager was successfully created"
    click_on "Back"
  end

  test "should update Office manager" do
    visit office_manager_url(@office_manager)
    click_on "Edit this office manager", match: :first

    fill_in "Name", with: @office_manager.name
    click_on "Update Office manager"

    assert_text "Office manager was successfully updated"
    click_on "Back"
  end

  test "should destroy Office manager" do
    visit office_manager_url(@office_manager)
    click_on "Destroy this office manager", match: :first

    assert_text "Office manager was successfully destroyed"
  end
end
