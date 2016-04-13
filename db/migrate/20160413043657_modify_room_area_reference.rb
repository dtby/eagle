class ModifyRoomAreaReference < ActiveRecord::Migration
  def change
    remove_reference :rooms, :area, index: true, foreign_key: true
    add_reference :rooms, :area, index: true
  end
end
