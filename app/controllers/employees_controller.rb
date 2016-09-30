class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  def get_all
    employee_sql = "SELECT a.id, a.employee_name, b.employee_name as Manager, d.department_name FROM employees a
        LEFT JOIN employees b
        ON a.manager_id = b.id
        LEFT JOIN departments_employees c
        ON a.id = c.employee_id
        LEFT JOIN departments d
        ON c.department_id = d.id
        ORDER BY a.id"
    employees = ActiveRecord::Base.connection.exec_query(employee_sql)
    headers = ["ID", "Name", "Manager", "Department"]
    render json: {:head => headers, :body => employees}
  end

  def get_all_employee_name
    @employees = Employee.all.pluck("id", "employee_name")
    render json: @employees
  end

  def filter_employee
    if params[:manager_id].blank?
      body = get_all
      employees = get_all_employee_name
      department =''
    else
      employee_sql = "SELECT a.id, a.employee_name, b.employee_name as Manager, d.department_name FROM employees a
        LEFT JOIN employees b
        ON a.manager_id = b.id
        LEFT JOIN departments_employees c
        ON a.id = c.employee_id
        LEFT JOIN departments d
        ON c.department_id = d.id
        WHERE b.id = #{params[:manager_id]}
        ORDER BY a.id"
      filter_employees = ActiveRecord::Base.connection.exec_query(employee_sql)
      department = Employee.find(params[:manager_id]).departments.ids.first
      employees = Department.find(department).employees.pluck("id", "employee_name")
      headers = ["ID", "Name", "Manager", "Department"]
      body = {:head => headers, :body => filter_employees}
    end
    render json: {:filter_employees => body, :employees => employees, :defaults => department}
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_name: params[:name], manager_id: params[:manager_id])
    if @employee.save
      @department_employee = DepartmentsEmployee.new(department_id: params[:department_id], employee_id: @employee.id)
      if @department_employee.save
        employees = Employee.select("id", "employee_name", "manager_id")
        if !employees.blank?
          headers = ["ID", "Name", "Manager", "Department"]
          render json: {:head => headers, :body => employees}
        end
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:manager_id, :employee_name)
  end

end
