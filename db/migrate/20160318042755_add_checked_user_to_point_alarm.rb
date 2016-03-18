class AddCheckedUserToPointAlarm < ActiveRecord::Migration
  def change
    add_column :point_alarms, :checked_user, :string
  end
end
