class OthersIndex < ActiveRecord::Base
  attr_accessible :blogID
  self.primary_key="blogID"
end
