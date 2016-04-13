class RemoveForeignKeys < ActiveRecord::Migration
  def change
    remove_foreign_key :alarm_histories, :points
    remove_foreign_key :alarms, :devices
    remove_foreign_key :attachments, :rooms
    remove_foreign_key :devices, :patterns
    remove_foreign_key :devices, :rooms
    remove_foreign_key :menus, :rooms
    remove_foreign_key :point_alarms, :devices
    remove_foreign_key :point_alarms, :points
    remove_foreign_key :point_alarms, :rooms
    remove_foreign_key :point_alarms, :sub_systems
    remove_foreign_key :point_histories, :devices
    remove_foreign_key :point_histories, :points
    remove_foreign_key :points, :devices
    remove_foreign_key :sub_rooms, :rooms
    remove_foreign_key :sub_systems, :systems
    remove_foreign_key :user_rooms, :rooms
    remove_foreign_key :user_rooms, :users

  end
end
