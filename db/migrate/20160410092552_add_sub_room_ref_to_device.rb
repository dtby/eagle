class AddSubRoomRefToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :sub_room_id, :integer
  end
end
