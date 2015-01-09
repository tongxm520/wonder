# encoding: utf-8
class Relationship < ActiveRecord::Base
  belongs_to	:requestee,:class_name=>"User"
  belongs_to	:requester,:class_name=>"User"
  
  def self.create_ship!(from,to,status)
     raise "自己不能加自己好友" if from==to
     r=Relationship.find_by_requester_id_and_requestee_id(from,to)
     if r
       if r.status!="accepted"#ignored,pending
         r.status = status
         r.save!  
       end     
     else
       Relationship.create!(:requester_id=>from,:requestee_id=>to,:status=>status)
     end
  end
end

=begin
SELECT distinct users.id,friendships.group_id FROM users INNER JOIN relationships ON users.id = relationships.requester_id left join friendships on relationships.id=friendships.relationship_id WHERE ((relationships.requestee_id = 1)) AND (relationships.status='accepted');

SELECT distinct users.id,friendships.group_id FROM users INNER JOIN relationships ON users.id = relationships.requestee_id left join friendships on relationships.id=friendships.relationship_id WHERE ((relationships.requestee_id = 1)) AND (relationships.status='accepted');
=end


