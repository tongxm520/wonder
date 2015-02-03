class CreateRestClients < ActiveRecord::Migration
  def self.up
    create_table :rest_clients do |t|
      t.string :name
      t.text :description
      t.string :api_key
      t.string :secret
      t.boolean :is_master, :default=>false
      t.boolean :is_disabled, :default=>false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :rest_clients
  end
end
