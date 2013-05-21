class Notice < ActiveRecord::Base
  attr_accessible :access_type, :content, :title ,:user_id

  attr_accessor :color ,:author
  #associations
  belongs_to :noticeboard
  belongs_to :user
  has_many :images 
  has_many :comments
  delegate :color , :name ,:to => :user ,:prefix => true

  scope :notice_with_settings , lambda { |user|
    begin
    	settings = user.setting
  		if settings
  			whr = []
  			if settings.notice_visibility == "0"
  				whr << "noticeboard_id=#{user.noticeboard.id}"
  			end
  			whr << "DATEDIFF( DATE( created_at ) , CURDATE( ) ) <= #{settings.date_visibility}"
  			return where(whr.join(" and "))
        #return whr.join(" and ")
  		end
	  rescue
  	 return where("")
    end
  }
  scope :public_notices, where(:access_type => 'public')
  scope :private_notices, where(:access_type =>'private')

  # after_save do
  #     return ApplicationController.publish(self.access_type,self.user_name)
  # end

  # after_destroy do
  #     return ApplicationController.publish(self.access_type,self.user_name)
  # end

  attr_accessible :access_type, :content, :title ,:user_id

  attr_accessor :color ,:author

  after_find do
    self.content = self.content.gsub(/\r/,'').gsub(/\n/,'<br>'.html_safe)
  end

  def as_json(options = { })
    h = super(options)
    image_ar = []
    comment_ar = []
    h['user_color'] =  self.user_color
    h['author'] = self.user_name
    h['updated_at']=self.updated_at.strftime("%d-%m-%Y")
    if self.images.count>0
      self.images.each do |img|
        image_ar << { :img_path => img.img(:thumb), :img_id => img.id } 
      end
    end
   if self.comments.count>0
      self.comments.each do |comment|
        comment_ar << { :comment=>comment.comment,:comment_id=>comment.id,:user_name=>comment.user.name,:comment_color=>comment.user.color}
      end
    end
    h['images'] = image_ar.as_json
    h['comments'] = comment_ar.as_json
    h
  end

  alias to_json as_json

  # def to_json
  #   return {
  #     :access_type => self.access_type,
  #     :content => self.content,
  #     :title => self.content,
  #     :color => self.user_color,
  #     :author => self.user_name,
  #     :updated_at => self.updated_at
  #     }.to_json
  # end

end
