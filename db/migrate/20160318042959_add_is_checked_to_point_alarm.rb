class AddIsCheckedToPointAlarm < ActiveRecord::Migration
  def change
    add_column :point_alarms, :is_checked, :boolean
  end
end
