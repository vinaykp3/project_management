class EmployeesController < ApplicationController
  require 'will_paginate/array'

  load_and_authorize_resource
  before_filter :find_employee, :only => [:show, :edit, :update, :destroy]


  def index
    if params[:search]
      @employees = Employee.accessible_by(current_ability).group("employees.id").order('created_at ASC').search(params[:search]).paginate(:page => params[:page], :per_page => 10)
    else
      #@employees = Employee.order('created_at ASC').paginate(:page => params[:page], :per_page => 10)
      @employees = Employee.accessible_by(current_ability).group("employees.id").order('created_at ASC').paginate(:page => params[:page], :per_page => 10)
    end
    respond_to do |format|
      format.js
      format.html # show.html.haml
      format.json { render json: @employees }
      format.xml { render :xml => @employees }
    end
  end

  def show
    @hr_categories = HrCategory.all
    @statutory = EmployeeStatutory.find_by_employee_id(params[:id])
    @employee_classifications=EmployeeDetail.where(:employee_id=>params[:id]).limit(1).order('created_at DESC')
    @employee_detail = EmployeeDetail.find_by_employee_id(params[:id])
    @employee_master_weekly_off = MasterWeeklyOff.employee_master_weekly_off params[:id]
    @employee_weekly_off=AttendanceWeeklyOff.find_all_by_employee_id(params[:id])
    @salary_rate = SalaryAllotment.find_by_employee_id(params[:id])
    @employee_allot_avail_settings = LeaveAllotAvailSetting.select("allot_settings,avail_settings,employee_id").where("employee_id = #{params[:id]}")
    #respond_to do |format|
    #  format.html # show.html.haml
    #  format.json { render json: @employee }
    #end
  end

  def new
    @employee = Employee.new
    respond_to do |format|
      format.html # _new_role_assignment.html.haml
      format.json { render json: @employee }
    end
  end

  def edit
    @employee_statutory = EmployeeStatutory.find_by_employee_id(params[:id])
    @reimbursement_allotments = ReimbursementAllotment.where("employee_id = #{@employee.id} AND allotment_date > '#{@employee.date_of_joining}'")
    @vol_pf_show = Company.first.pf
    if @employee_statutory.nil?
      @chk_pf_percentg = false
      @vpf_value = nil
      @display_panoption = true
      @based_on = nil
      @statutory=@employee.build_employee_statutory
    else
      !@employee_statutory.pan_present? ? @display_panoption = true : @display_panoption = false
      #@based_on = @employee_statutory.based_on
      #if @employee_statutory.vol_pf
      #  !@employee_statutory.vol_pf_percentage.nil? ? @chk_pf_percentg = true : @chk_pf_percentg = false
      #  @employee_statutory.vol_pf_percentage.nil? ? @vpf_value = @employee_statutory.vol_pf_amount : @vpf_value = @employee_statutory.vol_pf_percentage
      #end
    end


    render :layout => nil
  end

  def create
    @employee = Employee.new(params[:employee])
    #Employee.adult_when_joined?
    respond_to do |format|
      if @employee.save
        @employee.update_attributes :restrct_pf=>true
        classifications_headings = ClassificationHeading.select('id')
        classification = classifications_headings.each_with_object([]) { |(classification_head),tmp| tmp << "#{classification_head[:id]}=>NULL " }.join(',')
        @employee_details = EmployeeDetail.create(employee_id: @employee.id, effective_from: params[:employee][:salary_start_date], branch_id: params[:branch_id], salary_group_id: params[:salary_group_id], attendance_configuration_id: params[:attendance_configuration_id], classification: classification)
        EmployeeStatutory.create(:employee_id=>@employee.id)
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render json: @employee, status: :created, location: @employee }
      else
        format.html { render 'new' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    date_format=OptionSetting.date_format_value
    if date_format == "%m-%Y-%d" || date_format == "%m/%d/%Y" || date_format == "%d/%m/%y" || date_format == "%d-%m-%y"
      dates_value=[params[:employee][:date_of_birth],params[:employee][:date_of_joining], params[:employee][:probation_complete_date], params[:employee][:salary_start_date], params[:employee][:confirmation_date], params[:employee][:date_of_leaving], params[:employee][:retirement_date], params[:employee][:resignation_date]]
      dates = OptionSetting.convert_date(dates_value)
      params[:employee].merge!(:date_of_birth=>dates[0],:date_of_joining=>dates[1],:probation_complete_date=>dates[2],:salary_start_date=>dates[3], :confirmation_date=>dates[4], :date_of_leaving=>dates[5],:retirement_date=>dates[6],:resignation_date=>dates[7])
    else
      params[:employee]
    end
    if params[:doj_changed] == "1" || params[:sal_calc_changed] == "1"
      Employee.reset_all_records @employee, params[:employee]
    end
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        @statutory = EmployeeStatutory.find_by_employee_id(params[:employee][:id])
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render json: @employee }
        format.js
      else
        format.html { render 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    if !@employee.emp_salary_calculated
      @employee.destroy
      flash[:notice]="Employee Successfully Deleted."
      respond_to do |format|
        format.html { redirect_to employees_url }
        format.json { head :ok }
        format.js
      end
    else
      flash[:notice]="Employee can't be deleted, Salary is already calculated for selected employee."
      respond_to do |format|
        format.html { redirect_to employees_url }
        format.json { head :ok }
        format.js
      end
    end
  end

  # Upload excel sheet for bulk insertion employee
  def upload
    @invalid_upload_error = params[:invalid_upload_error] unless params[:invalid_upload_error].nil?
  end

  # save , parse and validate the excel file
  def upload_parse_validate
    require "roo"
    begin
      excel_file = params[:excel_file]
      file = FileUploader.new
      file.store!(excel_file)
      @employees = Employee.process_employee_details_excel_sheet file.store_path
      #binding.pry
      if @employees["errors"].empty?
        EmployeeExcelUpload.new(@employees["employees_save"], @employees["employees_update"]).save_update_employees
        count=@employees["employees_save"].uniq.count + @employees["employees_update"].uniq.count
        redirect_to employees_path
        flash[:notice] = "#{count} Employee Details are successfully updated."
      end
    rescue CarrierWave::IntegrityError => e
      @invalid_upload_error = e.message.gsub("xls, db,", "")
        redirect_to upload_employees_path(:invalid_upload_error => @invalid_upload_error)
    rescue TypeError
      @invalid_upload_error = "please upload a valid ExcelTemplate-xlsx file"
        redirect_to upload_employees_path(:invalid_upload_error => @invalid_upload_error)
    end
    file.remove!
  end

  def report
    @classification_headings = ClassificationHeading.order('display_order,classification_heading_name')
    if params[:report_type]
      @company = Company.first
      @report_type = params[:report_type]
      @report_type_change = params[:report_type].split("_").each{|word| word.capitalize!}.join(" ")
      @employees = Employee.accessible_by(current_ability).report_data params[:report_type],params[:report][:classification]
      respond_to do |format|
        format.html # _new_role_assignment.html.haml
        format.pdf do
          render :pdf => 'Report',
                 :handlers => [:haml],
                 :format => [:pdf],
                 :template => 'employees/report'
        end
      end
    end
  end

  def pf_contribution_restrict
    if params[:search]
      @employeesList = Employee.accessible_by(current_ability).order('created_at ASC').search(params[:search])
    else
      @employeesList = Employee.accessible_by(current_ability).order('created_at ASC')
    end
  end

  def pf_restrict_update
    params[:employee_data].each do |value|
      @val=Employee.find(value[:id])

      if value[:pf].nil?
        @val.update_attributes(:restrct_pf=>false)
      else
        @val.update_attributes(:restrct_pf=>true)
      end

      if value[:epf].nil?
        @val.update_attributes(:restrict_employer_pf=>false)
      else
        @val.update_attributes(:restrict_employer_pf=>true)
      end
    end
    redirect_to pf_contribution_restrict_employees_path
  end

  def generate_sample_excel_template
    complete_details = nil
    if params[:complete_details]
      complete_details = EmployeeDetail.complete_details
    end
    file = Employee.generate_excel_template(complete_details)

    send_file  file.path,
               :filename => File.basename(file),
               :type => File.ftype(file),
               :disposition => 'attachment'

    #p File.exists? file
    #FileUtils.rm_r(file.path)
  end

  def statutory_report
    @company = Company.first
    @e_format=params[:eReturn_format]
    if (params[:st_report] )
      @group= params[:group]
      @present_day= params[:present_days]
      @Emp_No = params[:Refno]
      @order= params[:Order_by]
      @report_type = params[:st_report]
      @paymonth = Paymonth.find_by_month_name(params[:month_year])
      if @report_type.downcase == "pf"
        @pf_group = PfGroup.find(params[:pf_group])
        @pf_group_rate = PfGroupRate.select("*").where("pf_group_id=#{@pf_group.id} AND NOT isempty(daterange(effective_from, effective_till)*daterange('#{@paymonth.from_date}','#{@paymonth.to_date}'))")
        @details =  PfCalculatedValue.pf_calculated_values params[:pf_group], @paymonth.from_date ,emp_id=""
      elsif @report_type.downcase == "esi"
        @esi_group=EsiGroup.find(params[:esi_group])
        #@esi_group_rate=EsiGroupRate.find_by_esi_group_id(@esi_group.id)
        @esi_group_rate=EsiGroupRate.select("*").where("esi_group_id=#{@esi_group.id} AND NOT isempty(daterange(effective_from, effective_till)*daterange('#{@paymonth.from_date}','#{@paymonth.to_date}'))")
        @details =  EsiCalculatedValue.esi_calculated_values params[:esi_group], @paymonth.from_date

      end
      respond_to do |format|
        format.xls do
          headers["Content-Disposition"] = "attachment; filename=\"#{@report_type.downcase}_report.xls\""
          render :xls => 'Report',
                 :format => [:xls],
                 :template => 'employees/statutory_report'
        end
      end
      #for esi_online format
      if ( @report_type.downcase == "esi online")
        file = EsiOnlineTemplate.esi_online params[:esi_group],params[:month_year]
        send_file  file.path,
                   :filename => File.basename(file),
                   :type => File.ftype(file),
                   :disposition => 'inline'
      end
    end
  end

  def employee_summary
    if params[:search]
      @search_item = params[:search]
      @employee = Employee.accessible_by(current_ability).search_specific(params[:search])
      if !@employee.blank?
        @earning_heads = EmployeeSummary.salary_heads(@employee[0].id,'Earnings')
        @deduction_heads = EmployeeSummary.salary_heads(@employee[0].id, 'Deductions')
        @theoret_earning_heads = EmployeeSummary.salary_heads(@employee[0].id, 'Earnings', 'theoretical_salary')
        @theoret_deductions_heads = EmployeeSummary.salary_heads(@employee[0].id, 'Deductions', 'theoretical_salary')

        @employee_summary = EmployeeSummary.employee_summary_record(@employee[0].id)
      end
    else
      @employee = nil
    end
  end

  protected
  def find_employee
    @employee = Employee.find(params[:id])
  end

end

