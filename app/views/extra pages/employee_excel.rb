class EmployeeExcel
  def self.create_excel_template(complete_details=nil)
    excel_package, wb = ExcelTemplate.define_axlsx()
    wb.styles do |s|
      instruction_cell, mandatory_cell, normal_cell, note_cell = ExcelTemplate.define_style(s)
      columns =define_columns(mandatory_cell, normal_cell)
      columns["Leave Policy"] = mandatory_cell if OptionSetting.first.lv_atdn_mgmt
      columns["Attendance Structure"]=mandatory_cell
      columns["Bank"]=normal_cell
      columns["Bank A/C No."]=normal_cell
      classification_headings = ClassificationHeading.order('display_order,classification_heading_name')
      classification_headings.each do |heading|
        columns.merge!("#{heading.classification_heading_name}"=>normal_cell)
      end

      unlocked = wb.styles.add_style :locked => false
      wb.add_worksheet(:name => "Instruction") do |sheet|
        ExcelTemplate.instruction_sheet(instruction_cell, mandatory_cell, normal_cell, note_cell, sheet)
        sheet.add_row ["", "", "", "Enter true for voluntary pf,tds,zero pt,zero pension"], :style => [0,0,0,note_cell]
      end

      wb.add_worksheet(:name => "Employee Details") do |sheet|
        #sheet.sheet_protection.password = 'default'
        sheet.add_row columns.map {""}, :style => columns.map { |key, value| columns["#{key}"]}
        sheet.add_row columns.map { |key, value| key}, :style => columns.map { |key, value| columns["#{key}"]}
        sheet.add_row (1..columns.length).to_a, :style => columns.map { |key, value| columns["#{key}"]}
        unless complete_details.nil?
          template_data = create_template_data complete_details
          template_data.each do |template_data|
            sheet.add_row columns.map { |key, value| template_data[key]}, :style => unlocked
          end
        end
        ExcelTemplate.fix_coordinates sheet,2,3,"C4"

        #(1..10000).each do |i|
        #  sheet.add_row columns.map { |key, value| }, :style => unlocked
        #end
      end
    end
    ExcelTemplate.return_file excel_package,"EmployeeDetails"
  end

  def self.define_columns(mandatory_cell, normal_cell)
    {
        "Emp ID" => mandatory_cell,
        "Employee name" => mandatory_cell,
        "Father's name" => normal_cell,
        "Marital status" => normal_cell,
        "Spouse Name" => normal_cell,
        "Gender" => normal_cell,
        "Date of birth" => normal_cell,
        "Date of joining" => mandatory_cell,
        "Salary Start date" => mandatory_cell,
        "Date of leaving" => normal_cell,
        "Residence no." => normal_cell,
        "Name of the residence" => normal_cell,
        "Street" => normal_cell,
        "Locality" => normal_cell,
        "City" => normal_cell,
        "State" => mandatory_cell,
        "Permanent address as Present" => normal_cell,
        "Permanent residence no." => normal_cell,
        "Permanent residence name" => normal_cell,
        "Permanent street" => normal_cell,
        "Permanent Locality" => normal_cell,
        "Permanent city" => normal_cell,
        "Permanent state" => normal_cell,
        "Email" => normal_cell,
        "Mobile" => normal_cell,
        "Restrict PF" => normal_cell,
        "Probation period" => normal_cell,
        "Probation complete date" => normal_cell,
        "Confirmation date" => normal_cell,
        "Retirement date" => normal_cell,
        "Handicapped" => normal_cell,
        "Emergency contact number" => normal_cell,
        "Official email id" => normal_cell,
        "Leaving reason" => normal_cell,
        "TDS"  => normal_cell,
        "PAN"     => normal_cell,                # if select ADD PAN then one more cell should be add.
        "Effective From(PAN)"  => normal_cell,   #Only enable when ADD PAN selected.
        "Voluntary PF"    => normal_cell,
        "PF No."          => normal_cell,
        "Effective from(PF)" => normal_cell,
        "ESI No."           => normal_cell,
        "Effective from(ESI)" => normal_cell,
        "Zero PT"          => normal_cell,
        "Effective from(Zero PT)"=> normal_cell,
        "Zero Pension"        => normal_cell,
        "Effective from(Zero Pen.)"=> normal_cell,
        "Structure" => mandatory_cell,
        "Branch" => mandatory_cell,

    }
  end

  def self.create_template_data(complete_details)
    template_data = []
    i=0
    complete_details.each do |employee|
      present_state = employee.present_state_id.nil? ? "" : State.find(employee.present_state_id).state_name
      perm_state = employee.perm_state_id.nil? ? "" : State.find(employee.perm_state_id).state_name
      structure = employee.salary_group_id.nil? ? "" : SalaryGroup.find(employee.salary_group_id).salary_group_name
      branch = employee.branch_id.nil? ? "" : Branch.find(employee.branch_id).branch_name
      leave_policy = employee.leave_policy_master_id.nil? ? "" : LeavePolicyMaster.find(employee.leave_policy_master_id).policy_name
      attendance_structure = employee.attendance_configuration_id.nil? ? "" : employee.attendance_configuration.attendance
      bank_name = employee.financial_institution_id.nil? ? "" : employee.financial_institution.name
      template_data << {
          "Emp ID" => employee.refno,
          "Employee name" => employee.empname,
          "Father's name" => employee.father_name,
          "Marital status" => employee.marital_status,
          "Spouse Name" => employee.spouse_name,
          "Gender" => employee.gender,
          "Date of birth" => excel_date_format(employee.date_of_birth),
          "Date of joining" => excel_date_format(employee.date_of_joining),
          "Salary Start date" => excel_date_format(employee.salary_start_date),
          "Date of leaving" => excel_date_format(employee.date_of_leaving),
          "Residence no." => employee.present_res_no,
          "Name of the residence" => employee.present_res_name,
          "Street" => employee.present_street,
          "Locality" => employee.present_locality,
          "City" => employee.present_city,
          "State" => present_state,
          "Permanent address as Present" => employee.perm_sameas_present.to_bool == true ?  "TRUE" : "",
          "Permanent residence no." => employee.perm_res_no,
          "Permanent residence name" => employee.perm_res_name,
          "Permanent street" => employee.perm_street,
          "Permanent Locality" => employee.perm_locality,
          "Permanent city" => employee.perm_city,
          "Permanent state" => perm_state,
          "Email" => employee.email,
          "Mobile" => employee.mobile,
          "Restrict PF" => employee.restrct_pf.to_bool == true ? "TRUE" : "",
          "Probation period" => employee.probation_period,
          "Probation complete date" => excel_date_format(employee.probation_complete_date),
          "Confirmation date" => excel_date_format(employee.confirmation_date),
          "Retirement date" => excel_date_format(employee.retirement_date),
          "Handicapped" => employee.handicapped.to_bool == true ? "TRUE" : "",
          "Emergency contact number" => employee.emergency_contact_number,
          "Official email id" => employee.official_mail_id,
          "Leaving reason" => employee.leaving_reason,
          "TDS"  => employee.tds_enable.to_bool == true ? "TRUE" : "",
          "PAN"     => employee.pan,
          "Effective From(PAN)"  => excel_date_format(employee.pan_effective_date),
          "Voluntary PF"    => employee.vol_pf.to_bool == true ? "TRUE" : "",
          "PF No."          => employee.pf_number,
          "Effective from(PF)" => excel_date_format(employee.pf_effective_date),
          "ESI No."           => employee.esi_number,
          "Effective from(ESI)" => excel_date_format(employee.esi_effective_date),
          "Zero PT"          => employee.zero_pt.to_bool == true ? "TRUE" : "",
          "Effective from(Zero PT)"=> excel_date_format(employee.zero_pt_effective_date),
          "Zero Pension"        => employee.zero_pension.to_bool == true ? "TRUE" : "",
          "Effective from(Zero Pen.)"=> excel_date_format(employee.zero_pension_effective_date),
          "Structure"            => structure,
          "Branch"               => branch,
          "Leave Policy"         => leave_policy,
          "Attendance Structure" => attendance_structure,
          "Bank"                 => bank_name ,
          "Bank A/C No."         => (employee.bank_account_number.nil? || employee.bank_account_number.strip.size==0) ? nil : "'#{employee.bank_account_number}"
      }
      classification_headings = ClassificationHeading.order('display_order,classification_heading_name')
      classification_headings.each do |heading|
        if employee.classification["#{heading.id}"]
          template_data[i].merge!("#{heading.classification_heading_name}"=> (employee.classification["#{heading.id}"].empty? ? "" :Classification.find(employee.classification["#{heading.id}"]).classification_name))
        end
      end
      i=i+1
    end

    template_data
  end
  def self.account_no employee
    acct_no=employee.bank_account_number
    if acct_no.nil? ||( acct_no.strip.size==0)
      return nil
    elsif acct_no[0]=="'" || acct_no[0]!=""
       return  "#{acct_no}"
    end
  end

  def self.excel_date_format(date)
    date.send(:nil?) ? "" : Date.parse(date).strftime("%d/%b/%Y")
  end
end