#encoding: utf-8
require File.expand_path('../restful_api_auth/checker.rb', __FILE__)

module RestfulApiAuth
  def authenticated?
    auth({})
  end

  def authenticated_master?
    auth({:require_master => true})
  end
  
  private
  
  def auth(opt)
    checker = RestfulApiAuth::Checker.new(params, request.fullpath)
    if checker.authorized?(opt)
      return true
    else
      @code = checker.errors[:code]
      if checker.show_errors
        @message = checker.errors[:msg]
        render "shared/error" and return if @render_format==:xml
        if @render_format==:json
           render :json => {:status=>@code,:message=>@message}.to_json
        end
      else
        render "shared/error" and return if @render_format==:xml
        if @render_format==:json
           render :json => {:status=>@code}.to_json
        end
      end
    end
  end
end



