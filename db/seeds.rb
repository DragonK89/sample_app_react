# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(1..50).each do |i|
  Department.create(department_name: 'BU '+ i.to_s, manager_id: i)
end

(1..200).each do |i|
  Employee.create(employee_name: 'huydt ' + i.to_s)
end

(1..50).each do |i|
  DepartmentsEmployee.create(department_id: i, employee_id: i)
end

(1..20).each do |i|
  DepartmentsEmployee.create(department_id: 1 , employee_id: i + 50)
end