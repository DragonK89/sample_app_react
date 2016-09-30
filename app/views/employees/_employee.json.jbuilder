json.extract! employee, :id, :dept_id, :manager_id, :employee_name, :created_at, :updated_at
json.url employee_url(employee, format: :json)