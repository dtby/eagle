class AddDeviceRefToAlarm < ActiveRecord::Migration
  def change
    add_reference :alarms, :device, index: true, foreign_key: true
  end
end
