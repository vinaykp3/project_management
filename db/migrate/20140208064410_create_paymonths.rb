class CreatePaymonths < ActiveRecord::Migration
  def change
    create_table :paymonths do |t|
      t.string :month_year
      t.date :from_date
      t.date :to_date
      t.timestamps
    end
  end
end
