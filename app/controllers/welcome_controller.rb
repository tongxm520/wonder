# encoding: utf-8

class WelcomeController < ApplicationController
  skip_before_filter :authorize #:except=> :index
  
  def index
    @posts = search_topics(Post,{},'面试')
  end
  
  def login
    if logged_in?
      redirect_to user_path(current_user)
    end
  end
  
  def register
    @user = User.new
  end
  
  def create
    arr = User.authenticate(params[:email],params[:password])
    if arr[0]
      self.current_user= arr[1]
      redirect_to user_path(arr[1])
    elsif arr[1]
      redirect_to login_url, :alert => %Q{帐号尚未激活，请<a target="_blank" href="/users/reactivate?email=#{arr[1].email}">点此激活</a>}
    else
      redirect_to login_url, :alert => "密码或帐号错误"
    end
  end
  
  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to login_url, :alert => "用户已经退出"
  end
end
