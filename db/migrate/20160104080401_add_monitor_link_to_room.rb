class AddMonitorLinkToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :monitor_link, :string
  end
end
