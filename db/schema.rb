# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_16_045054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "columns", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", null: false
    t.integer "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "linkedin_url", null: false
    t.string "website", default: "wwww.companyxwy.com"
    t.text "about", default: "about the company"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "job_positions", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: "job description should be here", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.boolean "applied", default: false, null: false
    t.integer "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lead_emails", force: :cascade do |t|
    t.string "email", default: "example@example.com", null: false
    t.string "subject", default: "write an eye catching email subject", null: false
    t.text "email_body", default: "compost an email...", null: false
    t.boolean "sent", default: false, null: false
    t.boolean "open", default: false, null: false
    t.integer "lead_id", null: false
    t.integer "job_position_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "picture_url", default: "https://mail.achieverspoint.com/img/default-avatar.jpg", null: false
    t.string "linkedin_url", null: false
    t.string "status", default: "new", null: false
    t.text "notes", default: "write a note...", null: false
    t.string "email"
    t.string "phone_number", default: "3462600832", null: false
    t.integer "position", null: false
    t.integer "column_id", null: false
    t.integer "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name", default: "default", null: false
    t.string "last_name", default: "default", null: false
    t.string "city", default: "default", null: false
    t.string "state", default: "default", null: false
    t.string "zipcode", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
