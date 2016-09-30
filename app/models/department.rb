class Department < ApplicationRecord
  has_and_belongs_to_many :employees, dependent: :destroy
  has_one :manager, class_name: "DepartmentsEmployee",
          foreign_key: "department_id"

end
