class AddAlarmTypeToPointAlarm < ActiveRecord::Migration
  def change
    add_column :point_alarms, :alarm_type, :integer
  end
end
