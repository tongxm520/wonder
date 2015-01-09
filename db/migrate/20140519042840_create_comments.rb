class CreateComments < ActiveRecord::Migration
  #post_comments,album_comments,mood_comments
  def self.up
    create_table :comments do |t|
      t.text :content
      t.integer :user_id,:null=>false
      t.integer :post_id,:null=>false	
      t.integer :replies_count,:default=>0
      t.string :user_name
      t.string :user_logo

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
