class Notice < ActiveRecord::Base
  attr_accessible :access_type, :author, :content, :title
  #associations
  belongs_to :noticeboard

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

  after_save do
      return ApplicationController.publish(self.access_type,self.author)
  end

  after_destroy do
      return ApplicationController.publish(self.access_type,self.author)
  end
end
