class Image < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :img
  has_attached_file :img, :styles => { :medium => "300x300>", :thumb => "30x30>" }, :default_url => "/images/:style/missing.png"
 # associations
 belongs_to :notice
end
