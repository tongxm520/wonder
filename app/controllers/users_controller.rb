# encoding: utf-8
class UsersController < ApplicationController
  skip_before_filter :authorize, :only=> [:create,:ajax_validate,:test_ajax,:confirm,:reactivate,:activate]

  def show
    if User.another_user?(current_user,params[:id])
      redirect_to profile_user_path(params[:id])
      return
    else
      @owner = "我"
    end
    @user = User.find(params[:id])
    respond_to do |format|
      format.html {render layout: "user"}
      format.xml  { render :xml => @user }
    end
  end
  
  def profile
    if User.another_user?(current_user,params[:id])
      @owner = "他"
      @owner_url = all_user_posts_path(params[:id])
    else
      @owner = "我"
      @owner_url = user_posts_path(params[:id])
    end
    @user = User.find(params[:id])
    render layout: "profile"
  end
  
  def account
    @owner = if User.another_user?(current_user,params[:id])
      "他"
    else
       "我"
    end
    @user = User.find(params[:id])
    render :layout=>"user"
  end
  
  def logo
    @owner = if User.another_user?(current_user,params[:id])
      "他"
    else
       "我"
    end
    @user = User.find(params[:id])
    render :layout=>"user"
  end
  
  def upload_logo
    msg = "上传文件失败。"
    if User.valid_image?(params[:uploaded_logo])
      begin
		     arr=User.upload_logo(params) 
		     msg = "上传文件成功。"
		   rescue Exception => e
		     Rails.logger.error "=============>#{e.message}"
      end 
      user=User.find_by_id(params[:id])
      user.nick_name = params[:nick_name] 
      user.logo_name = arr[0]
      user.logo_path = arr[1]
      user.small_logo_path = arr[2]
      user.medium_logo_path = arr[3]
      user.large_logo_path = arr[4]
      user.save(:validate=>false)
      self.current_user=user      
    end
    redirect_to logo_user_path(params[:id]),:alert=>msg
  end

  # POST /users
  def create
    params[:user][:birth]=User.birth(params[:year],params[:month],params[:day])
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        begin
          UserMailer.deliver_signup_notification(@user,Wonder::BASE_URL)
        rescue Exception => e
          Rails.logger.error "error when signup notification email for user:[#{@user.id}]   error_message:"+e.message #e.backtrace
        end	
        format.html { render :template => "users/confirm"  } 
      else
        format.html { render :template => "welcome/register"  } 
      end
    end
  end

  def ajax_validate
    id,value= params[:validateId],params[:validateValue]
    if value
      rtn=case id
      when "user_email"
        if User.find_by_email(value)
          [value,"ajaxUserEmail","false"]
        else
          [value,"ajaxUserEmail","true"]
        end
      end
    end
    render :json => {:jsonValidateReturn =>rtn }.to_json
  end
  
  def test_ajax
     @abc = JSON.parse(params[:abc])
     respond_to do |format|
       format.json  { render :json => {:jsonValidateReturn =>["ajaxUserEmail","false"] } }
     end    
  end
  
  def confirm
  end
  
  def reactivate
  end
  
  def activate
    user = User.find_by_activation_code(params[:id]) unless params[:id].blank?
    case
    when (!params[:id].blank?) && user && !user.active?
      user.activate!
			 self.current_user = user
		   redirect_to user_path(user)
    when params[:id].blank?
      flash.now[:error] =  "激活码缺失，请查收并点击您邮箱中的激活链接！"
      respond_to do |format|
        format.html
      end
    else 
      flash.now[:error]  = %Q{用户未找到，请查收您邮箱中的激活链接。或者此账号已激活，请尝试<a href="/login">登录</a>！}
      respond_to do |format|
        format.html
      end
    end
  end
end
