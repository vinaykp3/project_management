# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140308110647) do

  create_table "employees", force: true do |t|
    t.integer  "emp_id"
    t.string   "name"
    t.string   "gender"
    t.date     "date_of_joining"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monthly_activity_sheets", force: true do |t|
    t.integer  "month_id"
    t.integer  "project_id"
    t.integer  "employee_id"
    t.integer  "present_days"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paymonths", force: true do |t|
    t.string   "month_year"
    t.date     "from_date"
    t.date     "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_employees", force: true do |t|
    t.integer  "project_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "project_name"
    t.date     "project_commence_date"
    t.date     "project_completion_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
