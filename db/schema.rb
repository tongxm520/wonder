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

ActiveRecord::Schema.define(:version => 20150108122135) do

  create_table "categories", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "posts_count"
    t.integer  "user_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id",                      :null => false
    t.integer  "post_id",                      :null => false
    t.integer  "replies_count", :default => 0
    t.string   "user_name"
    t.string   "user_logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "subject",                       :null => false
    t.text     "content",                       :null => false
    t.integer  "category_id",                   :null => false
    t.integer  "user_id",                       :null => false
    t.string   "access"
    t.integer  "comments_count", :default => 0
    t.string   "category_name"
    t.string   "user_name"
    t.string   "user_logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "requester_id"
    t.integer  "requestee_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["requestee_id"], :name => "index_relationships_on_requestee_id"
  add_index "relationships", ["requester_id"], :name => "index_relationships_on_requester_id"

  create_table "replies", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "post_id",    :null => false
    t.integer  "comment_id", :null => false
    t.text     "content"
    t.string   "user_name"
    t.string   "user_logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "nick_name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "name"
    t.string   "city"
    t.string   "gender"
    t.date     "birth"
    t.string   "status"
    t.string   "agree"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.string   "logo_path"
    t.string   "logo_name"
    t.string   "small_logo_path"
    t.string   "medium_logo_path"
    t.string   "large_logo_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
