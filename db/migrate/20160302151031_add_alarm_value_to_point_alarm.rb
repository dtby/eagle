class AddAlarmValueToPointAlarm < ActiveRecord::Migration
  def change
    add_column :point_alarms, :alarm_value, :string
  end
end
