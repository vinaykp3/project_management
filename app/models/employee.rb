class Employee < ActiveRecord::Base
  belongs_to :projects

  def self.generate_excel
    require "rubygems" # if that is your preferred way to manage gems!
    require "axlsx"
    package = Axlsx::Package.new
    wb = package.workbook
    @employees = Employee.all
    wb.add_worksheet(name: "Basic Worksheet") do |sheet|
    sheet.add_row ["Employee Id","Employee Name","Gender","Date Of Joining"]
      @employees.each do |emp|
        sheet.add_row [emp.emp_id,emp.name,emp.gender,emp.date_of_joining]
      end
    end

    employee_xls ="#{Rails.root}/tmp/Basic.xlsx"
    file = File.new(employee_xls, "w")
    package.serialize(file)
    return file
 end

end
