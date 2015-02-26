class AddPinyinToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :pinyin, :string
  end

  def self.down
    remove_column :users, :pinyin, :string
  end
end
