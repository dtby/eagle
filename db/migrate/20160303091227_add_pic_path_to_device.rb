class AddPicPathToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :pic_path, :string
  end
end
