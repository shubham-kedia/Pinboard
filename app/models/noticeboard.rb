class Noticeboard < ActiveRecord::Base
  attr_accessible :name

  #associations
  belongs_to :board, :polymorphic => true
  
  has_many :notices
end
