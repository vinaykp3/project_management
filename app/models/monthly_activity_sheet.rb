class MonthlyActivitySheet < ActiveRecord::Base
  #acts_as_xlsx

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
    MonthlyActivitySheet.select("employees.name,monthly_activity_sheets.present_days").joins("full join employees on employees.id = monthly_activity_sheets.employee_id where monthly_activity_sheets.project_id = '#{project_selected}' and monthly_activity_sheets.month_id = '#{month_selected}'")
  end

  def generate_monthly_excel_template (month_selected,project_selected)
    require "axlsx"

    package = Axlsx::Package.new
    wb = package.workbook
    employee_details_result =  MonthlyActivitySheet.select("employees.name,projects.project_name,paymonths.month_year,monthly_activity_sheets.present_days").joins("inner join paymonths on paymonths.id = monthly_activity_sheets.month_id").joins("inner join projects on projects.id = monthly_activity_sheets.project_id").joins("full join employees on employees.id = monthly_activity_sheets.employee_id").where("monthly_activity_sheets.project_id = '#{project_selected}' and monthly_activity_sheets.month_id = '#{month_selected}'")
    wb.add_worksheet(name: "Monthly Activity Report") do |sheet|
      sheet.add_row ['Employee Name', 'Project Name', 'Month Year', 'Present Days']
      employee_details_result.each do |employee_details|
        sheet.add_row [employee_details.name, employee_details.project_name, employee_details.month_year, employee_details.present_days]
      end
    end
    monthly_excel_xls ="#{Rails.root}/public/Monthly.xlsx"
    file = File.new(monthly_excel_xls, "w")
    package.serialize(file)
    return file

  end


end
