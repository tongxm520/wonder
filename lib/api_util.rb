# encoding: utf-8
module ApiUtil
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def load_utils(options={})
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    protected
    
    def set_default_format
      @render_format = :xml
      if params["format"]&&params["format"]=="json"
        @render_format = :json
      end
      request.format = @render_format
    end
    
    def check_params
      unless ["v1", "v2"].include?(params[:version])
        msg="无效的版本号: #{params[:version]}，请检查api版本号"
        render_error("-6",msg) and return
      end
    end
    
    def render_error(code,message)
      @code=code
      @message = message
      render "shared/error"
    end
  end
end


