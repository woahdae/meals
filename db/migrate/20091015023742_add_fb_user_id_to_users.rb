class AddFbUserIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_id, :integer, :limit => 8 # makes it a bigint(20) in mysql
    add_column :users, :fb_email, :string
  end

  def self.down
    remove_column :users, :fb_email
    remove_column :users, :fb_id
  end
end
