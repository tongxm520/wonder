# encoding: utf-8
class Group < ActiveRecord::Base
  belongs_to :user
  has_many :friendships
  
  DefaultGroup={0=>"未分组",-1=>"挚交好友",-2=>"普通朋友"}
end
