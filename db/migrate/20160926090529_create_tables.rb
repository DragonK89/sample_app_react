class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :departments do |t|
      t.string :department_name
      t.belongs_to :manager, index: true
      t.timestamps
    end

    create_table :employees do |t|
      t.string :employee_name
      t.references :manager
      t.timestamps
    end

    create_table :departments_employees do |t|
      t.belongs_to :department, index: true
      t.belongs_to :employee, index: true
    end
  end
end
