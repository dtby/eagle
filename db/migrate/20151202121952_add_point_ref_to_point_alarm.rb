class AddPointRefToPointAlarm < ActiveRecord::Migration
  def change
    add_reference :point_alarms, :point, index: true, foreign_key: true
  end
end
