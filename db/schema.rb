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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130126183640) do

  create_table "animes", :force => true do |t|
    t.integer  "owner_id"
    t.string   "title"
    t.integer  "story_number"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "status"
  end

  create_table "stories", :force => true do |t|
    t.integer  "director_id"
    t.integer  "episode"
    t.text     "title"
    t.text     "description"
    t.datetime "deadline"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "anime_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login_id"
    t.string   "password"
    t.string   "mail_addr"
    t.string   "nick_name"
    t.string   "real_name"
    t.string   "phone_number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "last_login"
    t.integer  "account_type"
    t.integer  "account_status"
  end

end
