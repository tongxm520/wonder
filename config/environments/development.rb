Wonder::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  #config.time_zone = 'UTC'
  #config.time_zone = 'GMT'
  
  config.action_mailer.delivery_method = :smtp
  config.perform_deliveries = true 
  
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

=begin  
  config.action_mailer.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "gmail.com",
    :authentication => "plain",
    :user_name => "tong.xm520@gmail.com",
    :password => "icesword520",
    :enable_starttls_auto => true
 }
=end

config.action_mailer.smtp_settings = {    
  :address => "smtp.163.com",  
  :port => 25,  
  :domain => "163.com",  
  :authentication => :login, 
  :enable_starttls_auto => true, 
  :user_name => "tongxiaoming520@163.com",  
  :password => "7366087888"  
}  
  
end

