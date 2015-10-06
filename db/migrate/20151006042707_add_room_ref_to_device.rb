class AddRoomRefToDevice < ActiveRecord::Migration
  def change
    add_reference :devices, :room, index: true, foreign_key: true
  end
end
