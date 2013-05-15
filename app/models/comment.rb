class Comment < ActiveRecord::Base
  attr_accessible :comment, :notice_id, :user_id
  belongs_to :user
  belongs_to :notice
  
end
