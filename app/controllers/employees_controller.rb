class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      #Employee has been created
      redirect_to employees_url
    else
      render 'new'
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def index
    @employees = Employee.paginate(page: params[:page])
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(employee_params)
      redirect_to employees_url
    else
      render 'edit'
    end
  end

  def destroy
    @employee = Employee.find(params[:id]).destroy
    redirect_to employees_url
  end

  private

  def employee_params
    params.require(:employee).permit(:emp_id,:name,:gender,:date_of_joining)
  end

end
