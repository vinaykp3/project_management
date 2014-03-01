class ExcelTemplate

  def self.define_axlsx
    package = Axlsx::Package.new
    wb = package.workbook
    return package, wb
  end

  def self.define_style(s)
    mandatory_cell = s.add_style :bg_color => "808080", :b => true, :fg_color => "00", :sz => 10, :border => {:style => :thin, :color => "00"}, :alignment => {:horizontal => :center}
    normal_cell = s.add_style :bg_color => "CEE0DF", :b => true, :fg_color => "00", :sz => 10, :border => {:style => :thin, :color => "00"}, :alignment => {:horizontal => :center}
    instruction_cell = s.add_style :bg_color => "AA88CC", :b => true, :fg_color => "00", :sz => 10, :border => {:style => :thin, :color => "00"}, :alignment => {:horizontal => :center}
    note_cell = s.add_style :bg_color => "AADDFF", :fg_color => "00", :width => '1522', :b => true, :sz => 10, :border => {:style => :thin, :color => "00"}, :alignment => {:horizontal => :left}
    return instruction_cell, mandatory_cell, normal_cell, note_cell
  end

  def self.instruction_sheet(instruction_cell, mandatory_cell, normal_cell, note_cell, sheet)
      sheet.add_row
      sheet.add_row
      sheet.add_row ["", "", "", "Optional Fields           ","     "], :style => [0,0,0,instruction_cell, normal_cell]
      sheet.add_row ["", "", "", "Mandatory Fields          ","     "], :style => [0,0,0,instruction_cell, mandatory_cell]
      sheet.add_row []
      sheet.add_row []
      sheet.add_row ["", "", "", "Note                      ","     "], :style => [0,0,0,instruction_cell]
      sheet.add_row ["", "", "", "Avoid Cut options in any of the work Sheets"], :style => [0,0,0,note_cell]
      sheet.add_row ["", "", "", "To Enter Date Enter in DD/MMM/YYYY format (2/Jan/2005) Do no Cut or copy and Paste"], :style => [0,0,0,note_cell]
      sheet.add_row ["", "", "", "While Pasting data from other excel File,use only Paste Special / Values Option"], :style => [0,0,0,note_cell]
      sheet.add_row ["", "", "", "Before any operation on excel file make sure you are not in ExcelTemplate Edit mode"], :style => [0,0,0,note_cell]
      sheet.add_row ["", "", "", "Avoid using enter character ( Alt + Enter) in any cell "], :style => [0,0,0,note_cell]
  end

  def self.return_file package,name
    excel_det = "#{Rails.root}/public/system/#{name}.xlsx"
    file = File.new(excel_det, "w")
    package.serialize(file)
    return file
  end

  def self.fix_coordinates sheet,x,y,cell
    sheet.sheet_view.pane do |pane|
      pane.top_left_cell = "#{cell}"
      pane.state = :frozen_split
      pane.x_split = x
      pane.y_split = y
      pane.active_pane = :bottom_right
    end
  end

  def self.employee_instruction_reason_code(instruction_cell, normal_cell, num_cell,note_cell,default, sheet)
    sheet.add_row []
    sheet.add_row ['Reason', 'Code', 'Note'], :style => instruction_cell
    sheet.add_row ["Without Reason", "0", "Leave last working day as blank"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["On Leave	", "1 ", "Leave last working day as blank"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Left Service", "2", "Please provide last working day (dd/mm/yyyy). IP will not appear from next wage period"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Retired	", "3", "Please provide last working day (dd/mm/yyyy). IP will not appear from next wage period"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Out of Coverage", "4", "Please provide last working day (dd/mm/yyyy). IP will not appear from next contribution period.
This option is valid only if Wage Period is April/October. In case any other month then IP will
continue to appear in the list"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Expired", "5", "Please provide last working day (dd/mm/yyyy). IP will not appear from next wage period"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Non Implemented area", "6", "Please provide last working day (dd/mm/yyyy)."], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Compliance by Immediate Employer", "7", "Leave last working day as blank"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Suspension of work", "8", "Leave last working day as blank"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Strike/Lockout", "9", "Leave last working day as blank"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Retrenchment", "10", "Please provide last working day (dd/mm/yyyy). IP will not appear from next wage period"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["No Work", "11", "Leave last working day as blank"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row ["Doesnt Belong To This Employer", "12", "Leave last working day as blank"], :style => [note_cell, num_cell, note_cell]
    sheet.add_row []
    sheet.add_row []
    sheet.add_row ["Click Here to Go back to Data Entry Page","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row []
    sheet.add_row ["Instructions to fill in the excel file: ","",""], :style => [default, num_cell, normal_cell]
    sheet.add_row ["1. Enter the IP number,  IP name, No. of Days, Total Monthly Wages, Reason for 0 wages(If Wages ‘0’) & Last Working Day( only if employee
     has left service, Retired, Out of coverage, Expired, Non-Implemented area or Retrenchment. For other reasons,  last working day  must be left  BLANK).","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["2. Number of days must me a whole number.  Fractions should be rounded up to next higher whole number/integer","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["3. Excel sheet upload will lead to successful transaction only when all the Employees’ (who are currently mapped in the system) details
     are entered perfectly in the excel sheet ","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["4. Reasons are to be assigned numeric code  and date has to be provided as mentioned in the table above","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["5. Once  0 wages given and last working day is mentioned as in reason codes (2,3,4,5,10)  IP will be removed from the employer’s record. Subsequent months will not have this IP
    listed under the employer. Last working day should be mentioned only if 'Number of days wages paid/payable' is '0'..","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["6. In case IP has worked for part of the month(i.e. atleast 1 day wage is paid/payable) and left in between of the month, then last working day shouldn’t be mentioned.","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["7. Calculations – IP Contribution and Employer contribution calculation will be automatically done by the system","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["8. Date  column format is  dd/mm/yyyy or dd-mm-yyyy.  Pad single digit dates with 0.  Eg:- 2/5/2010  or  2-May-2010 is NOT acceptable.  Correct format  is 02/05/2010 or 02-05-
    2010","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["9. Excel file should be saved in .xls format (Excel 97-2003)","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["10. Note that all the column including date column should be in ‘Text’ format","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["10a. To convert  all columns to text,","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["         a.  Select column A; Click Data in Menu Bar on top;  Select Text to Columns ; Click Next (keep default selection of Delimited);  Click
                   Next (keep default selection of Tab); Select  TEXT;  Click FINISH.  Excel 97 – 2003 as well have TEXT to COLUMN  conversion
                    facility","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["         b.  Repeat the above step for each of the 6 columns. (Columns A – F )","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["10b.   Another method that can be used to text conversion is – copy the column with data and paste it in NOTEPAD.  Select the column (in
        excel) and convert to text. Copy the data back from notepad to excel","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["11.   If problem continues while upload,  download a fresh template by clicking 'Sample MC Excel Template'. Then copy the data area from   Step 8a.a – eg:  copy Cell A2 to F8 (if
    there is data in 8 rows); Paste it in cell A2 in the fresh template. Upload it ","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row  []
    sheet.add_row ["Note :   Kindly turn  OFF   ‘POP UP BLOCKER’  if it is ON in your  browser.  Follow the steps given to turn off  pop up blocker .
                 This  is required to  upload Monthly contribution,  view or print  Challan /  TIC after uploading the excel   ","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["                          1.Mozilla Firefox  3.5.11 :  From Menu Bar, select   Tools -> Options -> Content -> Uncheck (remove tick mark)                        ‘Block Popup Windows’.   Click OK","",""], :style => [normal_cell, num_cell, normal_cell]
    sheet.add_row ["                          2.  IE 7.0  :     From Menu Bar, select  Tools -> Pop up Blocker -> Turn Off Pop up Blocker ","",""], :style => [normal_cell, num_cell, normal_cell]



    sheet.column_widths 22,8,80
  end

end