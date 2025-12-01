json.extract! employee, :id, :name, :created_at, :updated_at
json.url employee_url(employee, format: :json)
json.office_manager employee.office_manager, :id, :name if employee.office_manager
json.office employee.office, :id, :number if employee.office
json.projects employee.projects, :id, :project_name, :description
