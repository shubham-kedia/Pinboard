class Notice < ActiveRecord::Base
  attr_accessible :access_type, :author, :content, :title
  #associations
  belongs_to :noticeboard

  default_scope do

  end
  scope :public_notices, where(:access_type => 'public')
  scope :private_notices, where(:access_type =>'private')
end
