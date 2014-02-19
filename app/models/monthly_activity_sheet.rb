class MonthlyActivitySheet < ActiveRecord::Base

  def employees_fetch_details
    Employee.all
  end

  def projects_fetch_details
    Project.all
  end

  def months_fetch_result
    Paymonth.all
  end

  def save_month_activity_sheet(month_id, project_id, emp_id_present_days)
    emp_id_present_days.each do |emp_id,p_days|
      MonthlyActivitySheet.create(month_id: month_id, project_id: project_id, employee_id: emp_id, present_days: p_days )
    end
  end

  def employee_month_project_result_set (month_selected,project_selected)
    Employee.select("employees.name,monthly_activity_sheets.present_days").joins("left join monthly_activity_sheets on monthly_activity_sheets.employee_id = employees.id where monthly_activity_sheets.project_id = '#{project_selected}' and monthly_activity_sheets.month_id = '#{month_selected}'")
  end

  def employee_result_set(project_selected)
    Employee.joins("left join project_employees on project_employees.employee_id = employees.id where project_employees.project_id = '#{project_selected}'")
  end
end
