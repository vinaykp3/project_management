class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      flash[:success] = "Employee has been created"
      redirect_to employees_url
    else
      flash[:danger] = @employee.errors.full_messages
      redirect_to new_employee_path
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def index
    @employees = Employee.paginate(page: params[:page])
    file= Employee.generate_excel
    respond_to do |format|
      format.html
      format.xlsx{
        send_file  file.path,
                   :filename => File.basename(file),
                   :type => File.ftype(file),
                   :disposition => 'attachment'
      }
    end

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
