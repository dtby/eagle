class AddCommentToPointAlarm < ActiveRecord::Migration
  def change
    add_column :point_alarms, :comment, :string
  end
end
