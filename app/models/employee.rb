class Employee < ApplicationRecord
  has_and_belongs_to_many :departments
  has_many :subordinates, class_name: "Employee",
           foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee", optional: true

end
