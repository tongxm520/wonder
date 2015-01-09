class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :subject, :null=>false
      t.text :content, :null=>false
      t.integer :category_id, :null=>false
      t.integer :user_id, :null=>false
      t.string :access #可见：任何人  好友  自己 密码 
      t.integer :comments_count,:default=>0
      t.string :category_name 
      t.string :user_name
      t.string :user_logo
      
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
