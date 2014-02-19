class MonthlyActivitySheetsController < ApplicationController
  def new
    @monthly_activity = MonthlyActivitySheet.new
    @months_fetch_result = @monthly_activity.months_fetch_result
    @projects_fetch_result = @monthly_activity.projects_fetch_details
    @employees_fetch_result = @monthly_activity.employees_fetch_details
  end

  def create
   @monthly_activity = MonthlyActivitySheet.new
   if @monthly_activity.save_month_activity_sheet(params[:month_id],params[:project_id],params[:emp_id_present_days])
     redirect_to monthly_activity_sheets_path
   end
  end

  def show
  end

  def index
    @monthly_activity = MonthlyActivitySheet.new
    @monthly_activity_months_fetch_result = @monthly_activity.months_fetch_result
    @monthly_activity_project_fetch_result = @monthly_activity.projects_fetch_details
  end

  def fetch_employees_for_month_project
    @monthly_activity = MonthlyActivitySheet.new
    @project_month_result_set = @monthly_activity.employee_month_project_result_set(params[:month_selected],params[:project_selected])
    render :partial => 'monthly_activity_sheets/result_set'
  end

  def fetch_employees_for_project_selected
    @result = ProjectEmployee.new
    @employees_fetch_result_set = @result.employee_result_set params[:project_selected]
    render :partial => 'monthly_activity_sheets/employee_result_set'
  end
end
