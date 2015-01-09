# encoding: utf-8
class FriendController < ApplicationController
  def profile
  end
  
  def manage
    @owner="我"
    @user = current_user
    @groups = Friendship.find_group(current_user.id)

    @friends = @user.friends(params[:group],current_user.id)
    render :layout=>'user'
  end
  
  def search
    @owner="我"
    @user = current_user
    @pendings = ActiveRecord::Base.connection.execute("SELECT `users`.* FROM `users` where id in (select relationships.requester_id from relationships  WHERE relationships.status='pending' and relationships.requestee_id='#{@user.id}' )")
    render :layout=>'user'
  end
  
  def know
    @owner="我"
    @user = current_user
    @users = @user.suggested_friends
    
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
    if f
      f.group_id=params[:group].to_i
      f.save
    end
    group = Group::DefaultGroup[params[:group].to_i]
    render :json => {:jsonReturn =>[params[:user_id],group] }.to_json
  end
end


