class AddCheckedUserToAlarmHistory < ActiveRecord::Migration
  def change
    add_column :alarm_histories, :checked_user, :string
  end
end
