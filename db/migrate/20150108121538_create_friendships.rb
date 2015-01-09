class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :group_id #0: 未分组 -1:挚交好友 -2:普通朋友
      
      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
