class ProjectEmployeesController < ApplicationController
  def new
    @project_employee = ProjectEmployee.new
    @project_fetch_result =  @project_employee.projects_data_fetch
    @employee_fetch_result = @project_employee.employees_data_fetch
  end

  def create
    @project_employee = ProjectEmployee.new
    if @project_employee.save_project_employees(params[:project_employee][:project_id], params[:project_employee][:employee_ids])
      redirect_to project_employees_path
    end
  end

  def edit

  end

  def index
    @project_employee = ProjectEmployee.new
    @employees_project_fetch_result = @project_employee.employees_for_project_fetch
  end

  def show

  end

  def fetch_employees_for_selected_project
    @employees = Employee.joins("left join project_employees on project_employees.employee_id = employees.id where project_employees.project_id = '#{params[:selected]}'")
    render :partial => 'project_employees/result_set'
  end

end




