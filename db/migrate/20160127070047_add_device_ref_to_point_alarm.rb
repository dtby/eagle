class AddDeviceRefToPointAlarm < ActiveRecord::Migration
  def change
    add_reference :point_alarms, :device, index: true, foreign_key: true
  end
end
