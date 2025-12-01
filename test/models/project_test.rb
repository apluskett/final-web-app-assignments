require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  setup do
    @project = projects(:website_redesign)
  end

  test "fixture is valid" do
    assert @project.valid?
  end

  test "project_name presence" do
    p = Project.new
    assert_not p.valid?
    assert_includes p.errors[:project_name], "can't be blank"
  end

  test "search finds by project_name" do
    results = Project.search(@project.project_name)
    assert_includes results.map(&:id), @project.id
  end
end
