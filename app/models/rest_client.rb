class RestClient < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true
  validates :api_key, :presence => true, :uniqueness => true
  validates :secret, :presence => true

  before_validation :set_defaults

	def gen_key
		`uuidgen`.chomp!
	end
	
	def gen_api_key
	  self.api_key= gen_key
	end
	
	def gen_secret
	  d = Digest::SHA256.new << gen_key
	  self.secret = d.to_s
	end
	
	def self.gen_url
	  client = RestClient.first
	  request_uri="/api/v1/users"
	  timestamp = Time.now.utc.strftime "%Y-%m-%d %H:%M:%S UTC"
    signature_string = client.secret + request_uri + timestamp
    digest = Digest::SHA256.new << signature_string
    signature = digest.to_s
    "#{request_uri}?api_key=#{client.api_key}&timestamp=#{timestamp}&signature=#{signature}"
	end
	
	private
	
	def set_defaults
	  self.gen_api_key if self.api_key.nil? || self.api_key == ""
	  self.gen_secret if self.secret.nil? || self.secret == ""
	  return true
	end
end



