class AddDataToUsersPinyin < ActiveRecord::Migration
  def self.up
    User.all.each do |user|
      user.pinyin = PinYin.of_string(user.name, :ascii).join.gsub!(/\d/,"")
      user.save
    end
  end

  def self.down
    User.all.each do |user|
      user.pinyin = nil
      user.save
    end
  end
end
