json.total_pages @point_alarms.total_pages
json.current_page @point_alarms.current_page

json.point_alarms @point_alarms do |point_alarm|
  json.id point_alarm.id
  json.pid point_alarm.pid
  json.state point_alarm.state
  json.created_at point_alarm.created_at
  json.is_checked point_alarm.is_checked
  json.point_id point_alarm.point_id
  json.comment point_alarm.comment
end