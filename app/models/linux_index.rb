class LinuxIndex < ActiveRecord::Base
  attr_accessible :blogID
  self.primary_key="blogID"
end
