class AddColumnsToPoint < ActiveRecord::Migration
  def change
    add_column :points, :u_up_value, :float, default: 0
    add_column :points, :d_down_value, :float, default: 0
    add_column :points, :main_alarm_show, :integer, default: 0
  end
end
