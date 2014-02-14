class CreateProjectEmployees < ActiveRecord::Migration
  def change
    create_table :project_employees do |t|
      t.references :project
      t.references :employee
      t.timestamps
    end
  end
end
