# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_27_041000) do
  create_table "assignments", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "project_id"], name: "index_assignments_on_employee_id_and_project_id", unique: true
    t.index ["employee_id"], name: "index_assignments_on_employee_id"
    t.index ["project_id"], name: "index_assignments_on_project_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "office_manager_id"
    t.index ["office_manager_id"], name: "index_employees_on_office_manager_id"
  end

  create_table "office_managers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offices", force: :cascade do |t|
    t.integer "number"
    t.integer "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_offices_on_employee_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  add_foreign_key "assignments", "employees"
  add_foreign_key "assignments", "projects"
  add_foreign_key "employees", "office_managers"
  add_foreign_key "offices", "employees"
end
