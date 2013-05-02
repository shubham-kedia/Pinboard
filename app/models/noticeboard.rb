class Noticeboard < ActiveRecord::Base
  attr_accessible :name

  #associations
  belongs_to :user

  has_many :notices
end
