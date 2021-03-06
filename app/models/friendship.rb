# encoding: utf-8
class Friendship < ActiveRecord::Base
  belongs_to :group
  
  def self.create_friendship(from, to)
    Friendship.create(:user_id=>from,:friend_id=>to,:group_id=>0)
    Friendship.create(:user_id=>to,:friend_id=>from,:group_id=>0)
  end
  
  def self.delete_friendship(from, to)
    ship=Friendship.find_by_user_id_and_friend_id(from,to)
    ship.destroy if ship
    ship=Friendship.find_by_user_id_and_friend_id(to,from)
    ship.destroy if ship
  end
  
  def self.find_group(id)
    hash={}
    ships=Friendship.where("user_id='#{id}'")
    ships.each do |r|
      hash[r["friend_id"]]=r["group_id"]
    end   
    hash
  end
end
