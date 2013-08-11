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

ActiveRecord::Schema.define(:version => 20130613031144) do

  create_table "blogs", :force => true do |t|
    t.string   "title",      :limit => 200,                       :null => false
    t.string   "author",     :limit => 50,                        :null => false
    t.string   "category",   :limit => 200,                       :null => false
    t.string   "abstract",   :limit => 300,                       :null => false
    t.text     "content",    :limit => 2147483647,                :null => false
    t.integer  "views",      :limit => 8,          :default => 0, :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "blogs", ["author"], :name => "index_blogs_on_author"
  add_index "blogs", ["title", "author"], :name => "index_blogs_on_title_and_author", :unique => true
  add_index "blogs", ["updated_at"], :name => "index_blogs_on_updated_at"
  add_index "blogs", ["views"], :name => "index_blogs_on_views"

  create_table "cpp_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cpp_indices", ["blogID"], :name => "index_cpp_indices_on_blogID", :unique => true
  add_index "cpp_indices", ["updated_at"], :name => "index_cpp_indices_on_updated_at"

  create_table "css_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "css_indices", ["blogID"], :name => "index_css_indices_on_blogID", :unique => true
  add_index "css_indices", ["updated_at"], :name => "index_css_indices_on_updated_at"

  create_table "git_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "git_indices", ["blogID"], :name => "index_git_indices_on_blogID", :unique => true
  add_index "git_indices", ["updated_at"], :name => "index_git_indices_on_updated_at"

  create_table "html_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "html_indices", ["blogID"], :name => "index_html_indices_on_blogID", :unique => true
  add_index "html_indices", ["updated_at"], :name => "index_html_indices_on_updated_at"

  create_table "java_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "java_indices", ["blogID"], :name => "index_java_indices_on_blogID", :unique => true
  add_index "java_indices", ["updated_at"], :name => "index_java_indices_on_updated_at"

  create_table "javascript_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "javascript_indices", ["blogID"], :name => "index_javascript_indices_on_blogID", :unique => true
  add_index "javascript_indices", ["updated_at"], :name => "index_javascript_indices_on_updated_at"

  create_table "linux_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "linux_indices", ["blogID"], :name => "index_linux_indices_on_blogID", :unique => true
  add_index "linux_indices", ["updated_at"], :name => "index_linux_indices_on_updated_at"

  create_table "others_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "others_indices", ["blogID"], :name => "index_others_indices_on_blogID", :unique => true
  add_index "others_indices", ["updated_at"], :name => "index_others_indices_on_updated_at"

  create_table "python_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "python_indices", ["blogID"], :name => "index_python_indices_on_blogID", :unique => true
  add_index "python_indices", ["updated_at"], :name => "index_python_indices_on_updated_at"

  create_table "ror_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ror_indices", ["blogID"], :name => "index_ror_indices_on_blogID", :unique => true
  add_index "ror_indices", ["updated_at"], :name => "index_ror_indices_on_updated_at"

  create_table "sql_indices", :id => false, :force => true do |t|
    t.integer  "blogID",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sql_indices", ["blogID"], :name => "index_sql_indices_on_blogID", :unique => true
  add_index "sql_indices", ["updated_at"], :name => "index_sql_indices_on_updated_at"

end
