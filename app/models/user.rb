class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me ,:name, :color, :gender, :contact_no
  # attr_accessible :title, :body

  # validates_presence_of :password ,:if => :new_record?
  #associations
  has_one :noticeboard
end
