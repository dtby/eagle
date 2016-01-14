class AddDeviceNameToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :device_name, :string
    remove_column :alarms, :point_index, :string
  end
end
