#encoding: utf-8
module RestfulApiAuth
  class Checker
    attr_accessor :request_uri, :errors
    attr_accessor :api_key, :signature, :timestamp
    cattr_accessor :show_errors
    @@show_errors=true
    
    def initialize(args,uri)
      @api_key=args["api_key"]
      @timestamp=args["timestamp"]
      @signature=args["signature"]
      @request_uri= uri
      @errors={}
    end
    
    def authorized?(options={})
      rtn=false
      unless have_required_args?
        @errors[:msg]= "one or more required args is missing"
        @errors[:code]="-1"
        return false
      end
      
      unless has_client?
        @errors[:msg]="This client is not found"
        @errors[:code]="-2"
        return false
      end
      
      if is_disabled?
        @errors[:msg]= "This client is disabled and cannot make calls to this API."
        @errors[:code]="-3"
        return false
      end
      
      if correct_signature?
        if options[:require_master] == true
          if is_master?
            rtn = true
          else
            @errors[:msg]=  "client does not have the required permissions"
            @errors[:code]="-4"
          end
        else
          rtn = true
        end
      else
        @errors[:msg]= "signature is invalid"
        @errors[:code]="-5"
      end   
      rtn
    end
    
    def have_required_args?
      !@api_key.nil?&&!@signature.nil?&&!@timestamp.nil?
    end
    
    # Direct string comparison is vulnerable to timing attacks, compare hashes instead
    # see: http://blog.jcoglan.com/2012/06/09/
    def correct_signature?
      client = RestClient.where(:api_key => @api_key).first
      sign=client.nil? ? "" : client.secret + @request_uri.gsub(/\?.*/,"")+@timestamp
      calculated_sign= (Digest::SHA256.new << sign).to_s
      Digest::SHA1.hexdigest(@signature)==Digest::SHA1.hexdigest(calculated_sign)
    end
    
    # determines if a RestClient is disabled or not
    def is_disabled?
      client = RestClient.where(:api_key => @api_key).first
      return true if client.nil?
      client.is_disabled
    end

    # determines if a RestClient has master privileges or not
    def is_master?
      client = RestClient.where(:api_key =>@api_key).first
      return false if client.nil?
      client.is_master
    end
    
    def has_client?
      RestClient.find_by_api_key(@api_key)
    end
  end
end


