json.total_pages @point_alarms.try(:total_pages) || 1
json.current_page @point_alarms.try(:current_page) || 1

if @point_alarms.present?
  json.alarm_size @point_alarms.total_entries  
  json.point_alarms @point_alarms do |point_alarm|
    json.id point_alarm.id
    json.device_name point_alarm.device_name
    json.pid point_alarm.pid
    json.room_id point_alarm.room_id
    json.reported_at point_alarm.reported_at.try(:strftime, "%Y-%m-%d %H:%M:%S")
    json.cleared_at point_alarm.cleared_at.try(:strftime, "%Y-%m-%d %H:%M:%S")
    json.checked_at point_alarm.checked_at.try(:strftime, "%Y-%m-%d %H:%M:%S")
    json.is_checked point_alarm.is_checked
    json.is_cleared point_alarm.is_cleared
    json.point_id point_alarm.point_id
    json.point_name point_alarm.device_name
    json.type point_alarm.alarm_type
    json.meaning point_alarm.meaning
    json.checked_user point_alarm.checked_user
  end
end