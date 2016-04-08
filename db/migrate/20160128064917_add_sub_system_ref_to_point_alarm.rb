class AddSubSystemRefToPointAlarm < ActiveRecord::Migration
  def change
    add_reference :point_alarms, :sub_system, index: true, foreign_key: true
  end
end
