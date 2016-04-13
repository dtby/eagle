class ChangeFieldsOfPointAlarm < ActiveRecord::Migration
  def change
    # remove_column(:point_alarms, :is_checked)
    add_column(:point_alarms, :checked_at, :datetime)
  end
end
