class AddUniqueIndexToAssignments < ActiveRecord::Migration[8.0]
  def change
    add_index :assignments, [ :employee_id, :project_id ], unique: true, name: "index_assignments_on_employee_id_and_project_id"
  end
end
