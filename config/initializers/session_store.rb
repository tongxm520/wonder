# Be sure to restart your server when you modify this file.
require 'memcache'
require 'memcache_util'

# memcache defaults, environments may override these settings
unless defined? MEMCACHE_OPTIONS then
  MEMCACHE_OPTIONS = {
    :debug => false,
    :namespace => "mem-#{Rails.env}",
    :readonly => false }
end

# memcache configuration
unless defined? MEMCACHE_CONFIG then
  File.open "#{Rails.root.to_s}/config/memcached.yml" do |memcache|
    MEMCACHE_CONFIG = YAML::load memcache
  end
end

# Connect to memcache
unless defined? CACHE then
  CACHE = MemCache.new MEMCACHE_OPTIONS
  CACHE.servers = MEMCACHE_CONFIG[Rails.env]
end


Wonder::Application.config.session_store :mem_cache_store, :key => "mem-#{Rails.env}", :cache => CACHE, :expire_after => 1800 ,:secret => "3ca87397-6f63-4cdd-9008-3e4ed83c2fae"

#Wonder::Application.config.session_store :cookie_store, key: '_wonder_session'


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Wonder::Application.config.session_store :active_record_store
