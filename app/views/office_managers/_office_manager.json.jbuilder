json.extract! office_manager, :id, :name, :created_at, :updated_at
json.url office_manager_url(office_manager, format: :json)
json.employees office_manager.employees, :id, :name
