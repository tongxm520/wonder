# encoding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "tongxiaoming520@163.com"
  
  def signup_notification(user,base_url)
    @user = user
    @base_url  = base_url
    mail(to: user.email, subject: '万达网(Wonder)的注册确认信')
  end
end

