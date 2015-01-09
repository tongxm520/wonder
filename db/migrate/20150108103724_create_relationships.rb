class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :requester_id
      t.integer :requestee_id
      t.string :status #pending,accepted,ignored
          
      t.timestamps
    end
    
    #add a foreign key  
    execute "ALTER TABLE relationships ADD CONSTRAINT fk_relationships_users_a FOREIGN KEY (requester_id) REFERENCES users(id)"
    
    execute "ALTER TABLE relationships ADD CONSTRAINT fk_relationships_users_b FOREIGN KEY (requestee_id) REFERENCES users(id)"
    
    add_index "relationships", ["requester_id"], :name => "index_relationships_on_requester_id"
    add_index "relationships", ["requestee_id"], :name => "index_relationships_on_requestee_id"
  end

  def self.down
    execute "ALTER TABLE relationships DROP FOREIGN KEY fk_relationships_users_a"
    execute "ALTER TABLE relationships DROP FOREIGN KEY fk_relationships_users_b"
    drop_table :relationships
  end
end
