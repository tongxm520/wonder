# encoding: utf-8
class FriendController < ApplicationController
  def profile
  end
  
  def manage
    @owner="我"
    @user = current_user
    @groups = Friendship.find_group(current_user.id)
    @grps = current_user.groups
    if params[:group].nil? or params[:group].to_i > -4
       @main_template = "friend_list"
    elsif params[:group].to_i==-4
       @main_template = "pending_list"
    elsif params[:group].to_i==-5 or params[:group].to_i==-6
       @main_template = "visit_list"
    end
    @friends = @user.friends(params[:group])
    render :layout=>'user'
  end
  
  def search
    @owner="我"
    @user = current_user
    @pendings = ActiveRecord::Base.connection.execute("SELECT `users`.* FROM `users` where id in (select relationships.requester_id from relationships  WHERE relationships.status='pending' and relationships.requestee_id='#{@user.id}' )")
    @users = @user.search(params[:query])
    render :layout=>'user'
  end
  
  def know
    @owner="我"
    @user = current_user
    arr = @user.suggested_friends
    @users=arr[0]
    @hash= arr[1]
    
    render :layout=>'user'
  end
  
  def invite
    @owner="我"
    @user = current_user
    render :layout=>'user'
  end
  
  def add_friend
    if current_user.is_friend_of?(params[:user_id])
      render :json => {:jsonReturn =>[params[:user_id],"false"] }.to_json
    else
      Relationship.create_ship!(current_user.id,params[:user_id].to_i,"pending")
      render :json => {:jsonReturn =>[params[:user_id],"true"] }.to_json
    end   
  end
   
  def decide
    raise "自己不能加自己好友" if current_user.id==params[:user_id].to_i
    
    user_name =User.find(params[:user_id]).name
    r=Relationship.find_by_requester_id_and_requestee_id(params[:user_id],current_user.id)
    r.status = params[:status]
    r.save
    
    if params[:status]=="accepted"
      Friendship.create_friendship(params[:user_id], current_user.id)
      render :json => {:jsonReturn =>[params[:user_id],"accepted",user_name] }.to_json
    else
      render :json => {:jsonReturn =>[params[:user_id],"ignored",user_name] }.to_json
    end 
  end
  
  def change_group
    f = Friendship.find_by_user_id_and_friend_id(current_user.id,params[:user_id])
    _group = params[:group].to_i
    if f
      f.group_id=_group
      f.save
    end
    group = _group>0 ? Group.find(_group).name : Group::DefaultGroup[_group]
    render :json => {:jsonReturn =>[params[:user_id],group] }.to_json
  end
  
  def create_group
		 params[:group][:user_id]=current_user.id
		 g=Group.new(params[:group])
		 g.save
    redirect_to "/friend/manage"
  end
  
  def delete_friend
    Relationship.delete_friend(current_user.id,params["friend_id"]) 
    render :json => {:id =>params["friend_id"] }.to_json
  end
  
  def find
    if params[:query]&&!params[:query].strip.blank?
      if params[:query].strip.downcase=~/^[a-z]+$/
		     col="pinyin"
		   elsif params[:query].strip=~/^[\u4e00-\u9fa5]{1,4}$/
		     col="name"
		   end
		   
		   if col
				 user_id = current_user.id
				 @groups = Friendship.find_group(user_id)
				 @grps = current_user.groups
				 fs= Friendship.where("user_id='#{user_id}'")
				 ids = fs.map{|f| f.friend_id }
				 
				 @friends = User.all(:conditions=>["id in (?) and #{col} like ?",ids,"%#{params[:query].strip}%"]) 
		   end
		 else
		   @friends=[]
    end
  end
end




