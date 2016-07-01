class AddTagToPoint < ActiveRecord::Migration
  def change
    add_column :points, :tag, :integer
  end
end
