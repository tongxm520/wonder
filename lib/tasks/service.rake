namespace	:memcache do
	desc "start memcache service"
	task :start do
		system "memcached -d -m 128 -l localhost -p 11211 -P /tmp/memcached.pid"
	end

	desc "stop memcache service"
	task :stop do
		system "kill `cat /tmp/memcached.pid`"
	end	
end

namespace :nginx do
	desc "start nginx service"
	task :start do
		system "nginx -c #{Rails.root.to_s}/config/nginx.cnf"
	end

	desc "stop nginx service"
	task :stop do
		system "ps x | awk '/[^\]]nginx: master/ {print $1}' | xargs kill"
		#or use follow line to kill the thread
		#killall -u $USER -v -i nginx
	end
end

namespace :thin do
  desc 'Start thin clusters'
  task :start do
    system "thin start -C /etc/thin/wonder.yml"
  end
 
  desc 'Stop thin clusters'
  task :stop do
    system "thin stop -C /etc/thin/wonder.yml"
  end
  
  desc 'Restart thin clusters'
  task :restart do
    system "thin restart -C /etc/thin/wonder.yml"
  end
end






