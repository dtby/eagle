class AddLineBToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :voltage2, :string
    add_column :alarms, :current2, :string
    add_column :alarms, :volt_warning2, :boolean
    add_column :alarms, :cur_warning2, :boolean
  end
end
