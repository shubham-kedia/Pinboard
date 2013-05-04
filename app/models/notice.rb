class Notice < ActiveRecord::Base
  attr_accessible :access_type, :author, :content, :title
  #associations
  belongs_to :noticeboard

  def self.default_scope
  	begin
  	puts User.current_id
		settings = UserSettings.find_by_user_id(User.current_id)
		if settings
			where = []
			if settings.notice_visibility == "0"
				where << "noticeboard_id=#{settings.user.noticeboard.id}"
			end
			where << "DATEDIFF( DATE( created_at ) , CURDATE( ) ) <= #{settings.date_visibility}"
			where(where.join(" and "))

		end
	 rescue
  	where("")
  end
  end
  scope :public_notices, where(:access_type => 'public')
  scope :private_notices, where(:access_type =>'private')
end
