#encoding: utf-8
class Post < ActiveRecord::Base
  has_many :comments, :dependent=> :destroy
  belongs_to :category
  belongs_to :user
  
  RootPath = "#{Rails.root.to_s}/public/uploads/posts"
  ACCESS = {"everyone" => "任何人可见", "friend"=>"仅好友可见","self"=>"私密日记"}
  
  define_index do
    indexes subject
    indexes content
    indexes comments.content, :as => :comments
    
    has comments(:id), :as => :comment_ids, :source => :ranged_query, :facet => true
    has category.name, :facet => true, :as => :category_name, :type => :string
    has user.name, :facet => true, :as => :user_name, :type => :string
    has 'COUNT(DISTINCT comments.id)', :as => :comments_count, :type => :integer
    has comments.created_at, :as => :comments_created_at
    
    has :category_id, :user_id
    #set_property :delta => :delayed
		 set_property :delta => :datetime, :threshold => Time.now.utc_offset+1.day
  end  
  
  #rmagick-2.13.1会出问题：uninitialize Constant Post::Magick
  #升级到rmagick 2.13.4解决问题
  def self.set_uploaded_file(source)
    FileUtils.mkdir_p(RootPath)
    key = Post.uuid_name
    #size: source[:imgFile].size
    #content_type: source[:imgFile].original_filename.split(".")[-1]
    
    basename=File.basename(source[:imgFile].original_filename,".*")
    save_file = "#{RootPath}/#{basename}_#{key}"
    
    img = Magick::Image.from_blob(source[:imgFile].read)[0]
    img.write(save_file)
    "/uploads/posts/#{basename}_#{key}"
  end
  
  def self.uuid_name
    _key =Digest::SHA2.hexdigest(`uuidgen`.strip!)
    [Time.now.strftime("%Y%m%d%H%M%S"), _key, '.png'].join('')
  end
end
