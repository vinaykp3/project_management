class CreateMonthlyActivitySheets < ActiveRecord::Migration
  def change
    create_table :monthly_activity_sheets do |t|
      t.references :month
      t.references :project
      t.references :employee
      t.integer :present_days

      t.timestamps
    end
  end
end
