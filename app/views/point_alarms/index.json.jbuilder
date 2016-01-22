json.total_pages @point_alarms.total_pages
json.current_page @point_alarms.current_page

if @point_alarms.present?
  json.point_alarms @point_alarms do |point_alarm|
    json.id point_alarm.try(:id)
    json.pid point_alarm.try(:pid)
    json.state point_alarm.try(:state)
    json.created_at point_alarm.try(:created_at)
    json.is_checked point_alarm.try(:is_checked)
    json.point_id point_alarm.try(:point_id)
    json.comment point_alarm.try(:comment)
  end
end