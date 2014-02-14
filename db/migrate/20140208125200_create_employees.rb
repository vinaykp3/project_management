class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :emp_id
      t.string :name
      t.string :gender
      t.date :date_of_joining

      t.timestamps
    end
  end
end
