class Blog < ActiveRecord::Base
  attr_accessible :abstract, :author, :category, :created_at, :content, :title, :updated_at, :views 
end
