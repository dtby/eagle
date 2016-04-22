class ModifyPointAlarmsAttributes < ActiveRecord::Migration
  def change
    remove_column :point_alarms, :alarm_type
    
    add_column :point_alarms, :alarm_type, :string
    add_column :point_alarms, :reported_at, :datetime
    add_column :point_alarms, :cleared_at, :datetime
    add_column :point_alarms, :meaning, :string
    add_column :point_alarms, :is_cleared, :boolean, index: true
    add_column :point_alarms, :device_name, :string
  end
end
