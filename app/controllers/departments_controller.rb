class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.all
    respond_to do |format|
      format.html
    end
  end

  def get_all
    department_sql = "SELECT d.id, d.department_name, a.employee_name, COUNT(c.department_id) - 1 FROM departments d
      INNER JOIN employees a
      ON d.manager_id = a.id
      INNER JOIN departments_employees c
      ON c.department_id = d.id
      GROUP BY c.department_id
      ORDER BY COUNT(c.department_id) DESC"
    departments = ActiveRecord::Base.connection.exec_query(department_sql)
    # headers = departments[0].attributes.keys
    headers = ["ID", "Name", "Manager", "Total Employees"]
    employee_count = DepartmentsEmployee.select("count(department_id) as scount").group("department_id").order("scount DESC").first
    render json: {:head => headers, :body => departments, :employee_count => employee_count}
  end

  def filter_departments
    department_sql = "SELECT d.id, d.department_name, a.employee_name, COUNT(c.department_id) -1 FROM departments d
      INNER JOIN employees a
      ON d.manager_id = a.id
      INNER JOIN departments_employees c
      ON c.department_id = d.id
      GROUP BY c.department_id
      HAVING COUNT(c.department_id) - 1 >= #{params[:filter]}
      ORDER BY COUNT(c.department_id) DESC"
    departments = ActiveRecord::Base.connection.exec_query(department_sql)
    headers = ["ID", "Name", "Manager", "Total Employees"]
    employee_count = DepartmentsEmployee.select("count(department_id) as scount").group("department_id").order("scount DESC").first
    render json: {:head => headers, :body => departments, :employee_count => employee_count}
  end

  def get_all_department_name
    @departments = Department.all.pluck("id", "department_name")
    render json: @departments
  end

  def filter_department_name
    if params[:department_id].blank?
      employee_sql = "SELECT a.id, a.employee_name, b.employee_name as Manager, d.department_name FROM employees a
        LEFT JOIN employees b
        ON a.manager_id = b.id
        LEFT JOIN departments_employees c
        ON a.id = c.employee_id
        LEFT JOIN departments d
        ON c.department_id = d.id
        ORDER BY a.id"
      filter_employees = ActiveRecord::Base.connection.exec_query(employee_sql)
      employees = Employee.all.pluck("id", "employee_name")
    else
      employee_sql = "SELECT a.id, a.employee_name, b.employee_name as Manager, d.department_name FROM employees a
        LEFT JOIN employees b
        ON a.manager_id = b.id
        LEFT JOIN departments_employees c
        ON a.id = c.employee_id
        LEFT JOIN departments d
        ON c.department_id = d.id
        WHERE d.id = #{params[:department_id]}
        ORDER BY a.id"
      filter_employees = ActiveRecord::Base.connection.exec_query(employee_sql)
      employees = Department.find(params[:department_id]).employees.pluck("id", "employee_name")
    end
    headers = ["ID", "Name", "Manager", "Department"]
    body = {:head => headers, :body => filter_employees}
    render json: {:employees => employees, :filter_employees => body}
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: 'Department was successfully created.' }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: 'Department was successfully updated.' }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url, notice: 'Department was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_department
    @department = Department.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def department_params
    params.require(:department).permit(:department_name, :manager_id)
  end
end
