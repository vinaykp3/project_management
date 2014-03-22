class Paymonth < ActiveRecord::Base
  validates :month_year, presence: true, uniqueness: true

  def self.to_from_date_create month_year
      date = Date.strptime(month_year,'%b/%Y')
      start_date = date.beginning_of_month
      end_date = date.end_of_month
      return start_date, end_date
   end
end

