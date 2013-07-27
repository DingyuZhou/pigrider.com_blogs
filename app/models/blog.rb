class Blog < ActiveRecord::Base
  attr_accessible :abstract, :author, :category, :created_at, :content, :title, :updated_at, :views
  
  
  validates_presence_of :title, :message=>"Blog title cannot be blank."
  validates_presence_of :content, :message=>"Blog content cannot be blank."
  validates_presence_of :category, :message=>"Please choose at least one category for your blog."
end
