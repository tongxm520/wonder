class Api::ApiController < ActionController::Base
  include ApiUtil
  include RestfulApiAuth
  
  load_utils  
  respond_to :json, :xml
  
  before_filter :set_default_format, :authenticated?, :check_params
end
