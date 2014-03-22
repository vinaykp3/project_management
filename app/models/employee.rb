class Employee < ActiveRecord::Base
  belongs_to :projects
  validates :emp_id, presence: true, :numericality => {:only_integer => true}
  EMPLOYEE_NAME_REGEX = /\A\D+\z/
  validates :name, presence: true, format: {:with => EMPLOYEE_NAME_REGEX , :message => "can be in Words only"}
  validates :gender, presence: true
  validates :date_of_joining, presence: true

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
