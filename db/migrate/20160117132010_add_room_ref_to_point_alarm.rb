class AddRoomRefToPointAlarm < ActiveRecord::Migration
  def change
    add_reference :point_alarms, :room, index: true, foreign_key: true
  end
end
