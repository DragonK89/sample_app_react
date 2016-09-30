Rails.application.routes.draw do
  get '/table_departments' => 'departments#get_all'
  post '/table_departments' => 'departments#filter_departments'

  get '/table_employees' => 'employees#get_all'
  post '/table_employees' => 'employees#create'
  get '/departments_name' => 'departments#get_all_department_name'
  post '/departments_name' => 'departments#filter_department_name'
  get '/employees_name' => 'employees#get_all_employee_name'
  post '/employees_name' => 'employees#filter_employee'
  # get '/filters_departments' => 'departments#test2'
  resources :employees
  resources :departments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
