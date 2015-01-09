class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.integer :user_id,:null=>false
      t.integer :post_id,:null=>false
      t.integer :comment_id,:null=>false
      t.text :content
      t.string :user_name
      t.string :user_logo
      
      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end
