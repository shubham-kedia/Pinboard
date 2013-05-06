module MyPublish

	# publis to author
	def self.publish(board_type)

		if board_type == 'public'
			puts 'public '

    	public_notices=::Notice.public_notices

    	notices = []

      public_notices.each do |notice|
        notices.push notice
      end

			# PrivatePub.publish_to(session[:channel],"load_notice(#{notices.to_json},'public')")
			PrivatePub.publish_to("/public_board","load_notice(#{notices.to_json},'public')")


		end

	end

end