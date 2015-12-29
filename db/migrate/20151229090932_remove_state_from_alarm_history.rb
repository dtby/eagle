class RemoveStateFromAlarmHistory < ActiveRecord::Migration
  def change
    remove_column :alarm_histories, :state, :integer
  end
end
