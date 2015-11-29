class AddLinkToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :link, :string
  end
end
