class Image < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :img
  has_attached_file :img, :styles => { :medium => "300x300>", :thumb => "100x100>" }
 # associations
 belongs_to :notice
end
