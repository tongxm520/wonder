class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :nick_name
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.string :name
      t.string :city
      t.string  :gender
      t.date     :birth
      t.string :status #工作 上学 其他
      t.string :agree 
      t.string   :remember_token                          
      t.datetime :remember_token_expires_at
      t.string   :activation_code                     
      t.datetime :activated_at
      t.string   "logo_path"
			 t.string   "logo_name"
				t.string   "small_logo_path"
				t.string   "medium_logo_path"
				t.string   "large_logo_path"
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end
end
