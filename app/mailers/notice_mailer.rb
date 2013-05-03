class NoticeMailer < ActionMailer::Base
  default from: "admin@notice.com"

  def send_notice_email(sender,receiver,title,date,content)
  	@content = content
  	@date = date
  	@title = title
    mail(:to => receiver, :subject => "#{sender} has sent you #{title} notice from notice.com").deliver
  end
end
