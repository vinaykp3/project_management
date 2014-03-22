class Project < ActiveRecord::Base
  has_many :employees
    validates :project_name, presence: true
    validates :project_commence_date, presence: true
    validates :project_completion_date, presence: true
end
