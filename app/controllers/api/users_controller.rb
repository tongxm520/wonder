class Api::UsersController < Api::ApiController
  def index
    @code = "0"
    @message = "OK"
    self.send("index_data_#{params[:version]}")
    return self.send("index_json_#{params[:version]}") if @render_format== :json
    render "api/#{params[:version]}/users/index"
  end
  
  def index_json_v1
    rtn = Hash.new
    rtn["status"]=@code
    rtn["message"]=@message
    rtn["users"]=[]
    @users.each do |u|
      h={}
      h["id"]=u.id
      h["name"]=u.name
      h["email"]=u.email
      h["gender"]=u.gender
      h["status"]=u.status
      h["city"]=u.city
      h["birth"]=u.birth
      rtn["users"] << h
    end
    render :json => rtn.to_json
    return true
  end
  
  def index_json_v2
    render :json => {:hello => "world"}.to_json
    return true
  end
  
  def index_data_v1
    @users = User.where("activation_code is NULL")
  end
  
  def index_data_v2
  end
end







