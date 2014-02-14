class ProjectEmployee < ActiveRecord::Base

  def projects_data_fetch
    Project.all
  end

  def employees_data_fetch
    Employee.joins('left join project_employees on project_employees.employee_id = employees.id where project_employees                            .project_id IS NULL')
  end

  def save_project_employees(project_id, employee_ids)
    employee_ids.each do |employee_id|
      ProjectEmployee.create(project_id: project_id, employee_id: employee_id)
    end
  end

  def employees_for_project_fetch
    Project.all
  end

end
