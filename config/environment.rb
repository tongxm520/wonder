# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Wonder::Application.initialize!

require 'thinking_sphinx'
require 'thinking_sphinx/deltas/datetime_delta.rb'
#undefined method  indexes  for Riddle::Configuration
#I was getting same error. Then I changed it to
#gem 'thinking-sphinx', '2.0.10' and issue was solved.




