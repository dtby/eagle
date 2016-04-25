# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/cron_log.log"
#
every 1.minutes do
  # runner "Point.monitor_db"
  runner "User.update_xinge_tags"
end

every 1.minutes do
  runner "Room.generate_point_value"
end

every 1.minutes do
  runner "Room.generate_alarm_data"
end

every 1.minutes do
  runner "PointHistory.generate_point_history"
end

every 3.minutes do
  runner "Room.get_computer_room_list"
end

every 1.minutes do
  runner "Room.generate_value_meaning"
end

every :hour do
  runner "Schedule.point_classify"
end

every 1.hour, :at => 15 do
  runner "Schedule.point_history"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
