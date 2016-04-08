class AddXingeInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :os, :string
    add_column :users, :device_token, :string
  end
end
