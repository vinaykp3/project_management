class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :project_name
      t.date :project_commence_date
      t.date :project_completion_date
      t.timestamps
    end
  end
end
