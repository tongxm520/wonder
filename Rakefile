# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Wonder::Application.load_tasks
require 'thinking_sphinx/tasks'

namespace :db do
  desc "Load seed fixtures (from db/fixtures) into the current environment's database."
  task :seed => :environment do
    require 'active_record/fixtures'
    Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
      Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
    end
  end
end

namespace	:memcache do
	desc "start memcache service"
	task :start do
		system! "memcached -d -m 128 -l localhost -p 11211 -P /tmp/memcached.pid"
	end

	desc "stop memcache service"
	task :stop do
		system! "kill `cat /tmp/memcached.pid`"
	end	
end


