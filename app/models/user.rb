class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :username
  has_secure_password
  
  validates :username, presence:true, length:{minimum:5,maximum:50}, uniqueness:true 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:true, format:{with:VALID_EMAIL_REGEX}
  validates :password, presence:true, length:{minimum:8,maximum:50}, :on=>:create
  validates :password_confirmation, presence:true, :on=>:create
  
 
  
  def questionOne
  end
  
  def questionTwo
  end
end
