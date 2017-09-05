# encoding: utf-8
require 'digest/sha2'

class User < ActiveRecord::Base
  validates :email, format: {with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, message: '请填写有效电子邮箱'}, :on => :create
  validates :password, format: {with: /^[a-zA-Z0-9~@#%&_\.\-\^\$\*\!\+\=]{6,16}$/,message: '必须由6-16个字母、数字或特殊字符组成'}, :on => :create
  validates :password, :confirmation => true , :on => :create
  validates :name ,format: {with: /^[\u4e00-\u9fa5]{2,4}$/,message: '中文姓名必须由2到4个汉字组成'}
  validates :city ,format: {with: /^[\u4e00-\u9fa5]{2,10}$/,message: '地名必须由2到10个汉字组成'}
  validates :agree, inclusion: { in: %w(1), message: "%{value} is invalid." }
  validates :status, inclusion: { in: %w(0 1 2), message: "%{value} is invalid." }
  validates :gender, inclusion: { in: %w(0 1), message: "%{value} is invalid." }
   
  attr_accessor :password_confirmation
  attr_reader   :password

  validate  :password_must_be_present
  validate  :email_unique, :on=> :create
  
  before_create	:make_activation_code, :set_pinyin
  
  has_many :posts
  has_many :comments
  has_many :groups

  
  has_many :requestee_relationships,:class_name=>"Relationship",:foreign_key=>"requester_id"
  has_many :requestees,:through=>:requestee_relationships,:source=>:requestee
  
  has_many :requester_relationships,:class_name=>"Relationship",:foreign_key=>"requestee_id"
  has_many :requesters,:through=>:requester_relationships,:source=>:requester
    
  STATUS = {"0" => "未工作","1"=>"在上学" ,"2"=>"在工作"}
  UserPath="#{Rails.root.to_s}/public/uploads/users"
  
  # 'password' is a virtual attribute
  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.encrypted_password = self.class.encrypt_password(password, salt)
    end
  end
  
  def active?
    activation_code.nil?
  end
  
  # Activates the user in the database.
  def activate!
    activate
    save(:validate => false)
  end
  
  def activate
    @activated = true
    self.activated_at = Time.now
    self.activation_code = nil
  end
 
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
=begin
select user_id,count(user_id) as same  from friendships where friend_id in (select friend_id from friendships  where user_id=1 ) and user_id in (6,7,8,9,10,16,17,18,19,20) and friend_id<>1 group by user_id order by same desc
=end
  #有共同好友的,从好友的好友中找，不包含已经发送请求或是好友关系的 
  def suggested_friends
    rs1=Relationship.where("requester_id='#{self.id}' and (status='pending' or status='accepted')")
    ids1= rs1.map{|r| r.requestee_id}
    rs2=Relationship.where("requestee_id='#{self.id}' and (status='pending' or status='accepted')")
    ids2 = rs2.map{|r| r.requester_id}
    rs3 = User.all(:conditions=>["activation_code is NULL and id not in (?)",ids1+ids2+[self.id]]) 
    ids3 =rs3.map{|r| r.id}
    _ids3=ids3.join(",")
   
    query=sanitize_sql(["select user_id,friend_id  from friendships where friend_id in (select friend_id from friendships  where user_id= '?' ) and user_id in ('?') and friend_id <> '?'",self.id,_ids3, self.id])
    rs=ActiveRecord::Base.connection.execute(query)
    
		hash={}
		rs.each_with_index do |r,i|
		   hash[r[0]]=[] if hash[r[0]].nil?
		   hash[r[0]] << r[1]
		end
		users = rs3.select{|r| hash.keys.include? r.id}
		users.sort_by! {|u| -hash[u.id].count}
		return 	users,hash
  end
  
  def search(keyword)
    rs1=Relationship.where("requester_id='#{self.id}' and (status='pending' or status='accepted')")
    ids1= rs1.map{|r| r.requestee_id}
    rs2=Relationship.where("requestee_id='#{self.id}' and (status='pending' or status='accepted')")
    ids2 = rs2.map{|r| r.requester_id}
    User.all(:conditions=>["activation_code is NULL and id not in (?)",ids1+ids2+[self.id]])
  end
  
  def is_friend_of?(user_id)
    arr1 = Relationship.where("requester_id='#{self.id}' and requestee_id='#{user_id}'")
    arr2 = Relationship.where("requestee_id='#{self.id}' and requester_id='#{user_id}'")
    return true if !arr1.empty? and arr1[0].status=="accepted" 
    return true if !arr2.empty? and arr2[0].status=="accepted" 
    return false 
  end
  
  def friends(group)
    if group.nil? or group=~/^\-\d+$/ or group=~/^\d+$/
		  _group = group.to_i
		  if group.nil? or _group ==-3
				 a = self.requesters.where("relationships.status='accepted'")
				 b = self.requestees.where("relationships.status='accepted'")
				 return a+b
		  elsif _group>-3
		    fs= Friendship.where("user_id='#{self.id}' and group_id='#{group}'")
		    ids = fs.map{|f| f.friend_id }
		    return User.all(:conditions=>["id  in (?)",ids]) 
		  end
		 elsif ('a'..'z').include?(group.downcase)
		   fs= Friendship.where("user_id='#{self.id}'")
		   ids = fs.map{|f| f.friend_id }
		   return User.all(:conditions=>["id in (?) and pinyin like ?",ids,"#{group.downcase}%"]) 
		 else
		   []
    end
  end
  
  def self.same_friend(user_id,id)
    query=sanitize_sql(["select user_id,friend_id  from friendships where friend_id in (select friend_id from friendships  where user_id='?' ) and user_id='?' and friend_id <> '?'",user_id,id,user_id])
    rs=ActiveRecord::Base.connection.execute(query)
    rs.count
  end

=begin
select distinct relationships.requestee_id,friendships.group_id from relationships left join friendships on friendships.relationship_id=relationships.id  where relationships.requester_id=1 and relationships.status='accepted';

select distinct relationships.requester_id,friendships.group_id from relationships left join friendships on friendships.relationship_id=relationships.id  where relationships.requestee_id=1 and relationships.status='accepted';
=end
 
  class << self
    def birth(year,month,day)
      #20.days.ago.to_date.to_s
      return year + "-" +month+ "-" +day
    end    
    
    def authenticate(email, password)
				if user = find_by_email(email)
				  if user.encrypted_password == encrypt_password(password, user.salt)
				    if user.active?
				      return [true,user]
				    else
				      return [false,user]
				    end
				  end
				end
				[false,nil]
    end

		 def encrypt_password(password, salt)
			  Digest::SHA2.hexdigest(password + "wibble" + salt)
		 end
		 
		 def secure_digest(*args)
      Digest::SHA2.hexdigest(args.flatten.join('--'))
    end
    
		 def make_token
			 secure_digest(Time.now, (1..10).map{ rand.to_s })
		 end
		 
		 def valid_image?(file)
		   format = file.original_filename.split(".")[-1] =~ /jpg|jpeg|png|gif|bmp/
		   size = file.size <= 2*1024*1024 #小于2M
		   format&&size
		 end
  end
  
  def User.another_user?(current_user,another)
    current_user && current_user.id != another.to_i
  end
  
  def self.upload_logo(hash)
    path= "/#{hash[:id]}/logo"
    FileUtils.mkdir_p "#{UserPath}#{path}"
    original_type = hash[:uploaded_logo].original_filename.split(".")[-1]
    basename = File.basename(hash[:uploaded_logo].original_filename,".*")
    
    _now = Time.now.strftime("%Y%m%d%H%M%S")
    _path = "/#{UserPath.split("/")[-2..-1].join("/")}"
    
    logo_name = "#{basename}"
    save_logo_path = "#{UserPath}#{path}/#{logo_name}_#{_now}.#{original_type}" 
    logo_path="#{_path}#{path}/#{logo_name}_#{_now}.#{original_type}"
     
    small_logo_name = "#{basename}_small"
    save_small_logo_path="#{UserPath}#{path}/#{small_logo_name}#{_now}.#{original_type}" 
    small_logo_path="#{_path}#{path}/#{small_logo_name}#{_now}.#{original_type}" 
     
    medium_logo_name = "#{basename}_medium"
    save_medium_logo_path="#{UserPath}#{path}/#{medium_logo_name}#{_now}.#{original_type}"
    medium_logo_path="#{_path}#{path}/#{medium_logo_name}#{_now}.#{original_type}"
    
    large_logo_name = "#{basename}_large"
    save_large_logo_path = "#{UserPath}#{path}/#{large_logo_name}#{_now}.#{original_type}"
    large_logo_path = "#{_path}#{path}/#{large_logo_name}#{_now}.#{original_type}"
    
    img = Magick::Image.from_blob(hash[:uploaded_logo].read)[0]
    img.write(save_logo_path)
    
		 thumbnail = img.resize_to_fill(50, 50)
		 thumbnail.write(save_small_logo_path)
		 
		 thumbnail = img.resize_to_fill(120, 120)
		 thumbnail.write(save_medium_logo_path)
		 
		 thumbnail = img.resize_to_fill(180, 180)
		 thumbnail.write(save_large_logo_path)
		 [logo_name,logo_path,small_logo_path,medium_logo_path,large_logo_path]
  end
  
  private

  def password_must_be_present
    errors.add(:password, "Missing password") unless encrypted_password.present?
  end
  
  def email_unique
		 if User.find_by_email(self.email)
		   errors.add(:email,"该邮箱已经注册，请您换一个邮箱")
		 end
  end
  
  def birth_valid?(year, month,day)
    begin
      @date = Date.new(year.to_i, month.to_i, day.to_i)
      return @date>=Date.new(1900,1,1)&&@date<=Time.now.to_date
    rescue ArgumentError
      return false
    end
  end
  
  def check_birth
    unless birth_valid?
      errors.add(:birth,"日期格式错误或不在范围内")
    end
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def make_activation_code
    self.activation_code = self.class.make_token
  end
  
  def set_pinyin
    self.pinyin = PinYin.of_string(self.name, :ascii).join.gsub!(/\d/,"")
  end
end


=begin
self.errors.add_to_base(self.class.instance_variable_get(:@message)) 
self.errors.add(:captcha, self.class.instance_variable_get(:@message))
flash.now[:error]            
@reply.errors.full_messages.join(',')

DUPLICATE_RECORD_ERRORS = [
  /^Mysql::Error:\s+Duplicate\s+entry\b/,
  /^PG::Error:\s+ERROR:\s+duplicate\s+key\b/,
  /\bConstraintException\b/
]

def self.duplicate_record_error?(error)
  error.class.name == 'ActiveRecord::RecordNotUnique' or
  DUPLICATE_RECORD_ERRORS.any? { |re| re =~ error.message }
end
=end
 
