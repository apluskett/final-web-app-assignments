json.extract! office, :id, :number, :employee_id, :created_at, :updated_at
json.url office_url(office, format: :json)
json.employee office.employee, :id, :name if office.employee
