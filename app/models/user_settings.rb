class UserSettings < ActiveRecord::Base
  belongs_to :user
  attr_accessible :auto_delete, :date_visibility, :notice_visibility


  def default_settings
  	self.auto_delete = 30
  	self.date_visibility = 5
  	self.notice_visibility = 1
  end

  after_create do
  	self.default_settings
  	self.save
  end
end
