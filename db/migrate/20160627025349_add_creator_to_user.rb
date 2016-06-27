class AddCreatorToUser < ActiveRecord::Migration
  def change
    add_column :users, :creator, :integer, default: 1
  end
end
