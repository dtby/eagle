class RemoveRoomIdFromSystem < ActiveRecord::Migration
  def change
    remove_reference :systems, :room, foreign_key: :room_id
  end
end
