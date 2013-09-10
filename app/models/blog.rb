class Blog < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
    
    
  attr_accessible :abstract, :author, :category, :created_at, :content, :title, :updated_at, :views
  
  
  validates_presence_of :title, :message=>"Blog title cannot be blank."
  validates_presence_of :content, :message=>"Blog content cannot be blank."
  validates_presence_of :category, :message=>"Please choose at least one category for your blog."
  
  
  searchable do
    text :title, :stored=>true
    text :author, :stored=>true
    text :category, :stored=>true
    
    text :content, :stored=>true do
      strip_tags(content)
    end
  end
end
