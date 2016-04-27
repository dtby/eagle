class AddReportShowToPoint < ActiveRecord::Migration
  def change
    add_column :points, :s_report, :integer, default: 0
  end
end
