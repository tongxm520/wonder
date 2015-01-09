# encoding: utf-8
class PostsController < ApplicationController
  #session失效,protect_from_forgery导致的

  def index
    if User.another_user?(current_user,params[:user_id])
      redirect_to  all_user_posts_path(params[:user_id])
      return
    else
      @owner = "我"
    end
    @user = User.find(params[:user_id])
    #Post.all(:conditions=>["user_id=?",1])
    #Customer.where("department_id = ? OR department_id IS NULL", current_user.id)
    @posts = Post.where("user_id = '#{params[:user_id]}'").order("created_at desc")
    render :layout=>"user"
  end
  
  def new
    @owner = if User.another_user?(current_user,params[:user_id])
      "他"
    else
       "我"
    end
    @user = User.find(params[:user_id])
    @post =Post.new
    render :layout=>"user"
  end
  
  def create
    @user = User.find(params[:user_id])
    params[:post][:user_id]=params[:user_id]
    c=Category.find(params[:post][:category_id])
    params[:post][:category_name]=c.name
    @post = Post.new(params[:post])
    
    respond_to do |format|
      if @post.save
        format.html {redirect_to user_posts_path(@user)}
      else
        format.html {render :action => "new",:layout=>"user"}
      end
    end
  end
  
  def edit
    @owner = if User.another_user?(current_user,params[:user_id])
      "他"
    else
       "我"
    end
    @user = User.find(params[:user_id])
    @post =Post.find(params[:id])
    render :layout=>"user"
  end
  
  def update
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(user_post_path(@user,@post), :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :layout=>"user" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @user = User.find(params[:user_id])
    included=@user.posts.map {|p|p.id}.include? params[:id].to_i
    if !included
      redirect_to  display_user_post_path(params[:user_id],params[:id])
      return   
    elsif User.another_user?(current_user,params[:user_id])      
      redirect_to  display_user_post_path(params[:user_id],params[:id])
      return 
    else
      @owner = "我"  
    end    
    @post =Post.find(params[:id])
    @comments = Comment.where("post_id='#{params[:id]}'").order("created_at desc") 
    render :layout=>"user"
  end
    
  def upload
    #TODO: 传个user_id过来
    #TODO: 阅读js中name=imgFile的代码
    msg = "上传文件失败。"
    if params[:imgFile].original_filename.split(".")[-1] =~ /jpg|jpeg|png|gif|bmp/
      begin
		     filename = Post.set_uploaded_file(params) 
		   rescue Exception => e
		     Rails.logger.error "=============>#{e.message}"
		     render :text => %<{"error": 1, "message": "#{msg}"}>
		     return
      end 
      render :text => %<{"error": 0, "url": "#{filename}"}>
      return
    end
    render :text => %<{"error": 1, "message": "#{msg}"}>
  end
  
  def delete
    @post =Post.find(params[:id])
    @post.destroy if @post

    render :json => {:post_id => params[:id] }.to_json
  end
  
  def del
    @post =Post.find(params[:id])
    @post.destroy if @post
    redirect_to user_posts_path(params[:user_id])
  end
  
  #TODO:http://localhost:3000/users/1/posts/6/display
  def display
    @u = User.find(params[:user_id])
    @post =Post.find(params[:id]) 
    
    included=@u.posts.map {|p|p.id}.include? params[:id].to_i
    if !included
      if User.another_user?(current_user,@post.user.id) 
       @owner = "他"
       @user = @post.user
       @owner_url = all_user_posts_path(@user) 
      else
       @owner = "我"
       @user = current_user
       @owner_url = user_posts_path(@user) 
      end      
    else
      if User.another_user?(current_user,params[:user_id]) 
       @owner = "他"
       @user = @u
       @owner_url = all_user_posts_path(@user) 
      else
       @owner = "我"
       @user = current_user
       @owner_url = user_posts_path(@user) 
      end
    end
      
    @comments = Comment.where("post_id='#{params[:id]}'").order("created_at desc") 
    render :layout=>"profile"
  end
  
  def all
    if User.another_user?(current_user,params[:user_id])
      @owner ="他"
      @owner_url = all_user_posts_path(params[:user_id])
    else
      @owner ="我"
      @owner_url = user_posts_path(params[:user_id])
    end
    @user = User.find(params[:user_id])
    @posts = Post.where("user_id = '#{params[:user_id]}'").order("created_at desc")
    render :layout=>"profile"
  end
end


