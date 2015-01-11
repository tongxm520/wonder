require "#{Rails.root.to_s}/lib/authentication_system"

class ApplicationController < ActionController::Base
  #protect_from_forgery
=begin
Rails2.x后引入了防止跨域访问攻击的pluging，具体操作如下
在控制器中定义protect_from_forgery钩子，在模版中使用form_for等标签时，服务器会在生成form_for等标签时建立一个 密钥(token)，服务器会监视request回来的所有post以及AJAX行为，如果request没有token或者与服务器计算出的不一致，将 返回错误信息。
cookiestore的session存储机制下，token是根据CGI::Session.generate_unique_id生成的随即数并进行编码得到的，所以不需要为protect_from_forgery设置secret的键值
:active_record_store或者:mem_cache_store是根据session_id、protect_from_forgery的secret的值以及digest（默认是SHA1）计算得来，所以要为这种session机制设置secret值。
=end
  before_filter :authorize
  
  include AuthenticationSystem
  
  def search_topics(clazz,scope,query='',*others)
    #scope ||= {:category_id=>@category.id}
    other_params={:with=>scope,:match_mode=>:extended}
    other_params.merge! others.first unless others.blank?

    if query.blank?
       []
    else
      clazz.search query, other_params
    end
  end
  
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url,:notice =>"Please log in"
    end
  end
end




=begin
ApplicationController.new.search_topics(Post,{:category_id=>1},'with')
ApplicationController.new.search_topics(Post,{},'with')
ApplicationController.new.search_topics(Post,{},'with', :limit=>3)
ApplicationController.new.search_topics(Post,{},'with',:per_page =>10,:page => 1)

ApplicationController.new.search_topics(Post,{:category_id=>3},'面试')
ApplicationController.new.search_topics(Post,{:category_id=>1},'面试')
ApplicationController.new.search_topics(Post,{:category_id=>1,:user_id=>2},'面试')
=end

