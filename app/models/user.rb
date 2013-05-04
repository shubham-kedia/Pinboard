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
  validates_uniqueness_of :email
  has_one :setting ,:class_name => 'UserSettings'

  after_create do
    self.setting = UserSettings.new
  end

  def self.current_id
    Thread.current[:user]
  end
  def self.current_id=(user)
    Thread.current[:user] = user.id
  end
end
