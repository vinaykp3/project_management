class ExcelTemplate
  def define_axlsx
    package = Axlsx::Package.new
    wb = package.workbook
  end
end