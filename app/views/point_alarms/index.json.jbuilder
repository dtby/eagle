json.total_pages @point_alarms.try(:total_pages) || 1
json.current_page @point_alarms.try(:current_page) || 1

if @point_alarms.present?
  
  json.point_alarms @point_alarms do |point_alarm|
    json.id point_alarm.try(:id)
    json.device_name point_alarm.try(:point).try(:device).try(:name)
    json.pid point_alarm.try(:pid)
    json.state point_alarm.try(:state)
    json.created_at point_alarm.try(:created_at).try(:strftime, "%Y-%m-%d %H:%M:%S")
    json.updated_at point_alarm.try(:updated_at).try(:strftime, "%Y-%m-%d %H:%M:%S")
    json.is_checked point_alarm.try(:is_checked)
    json.point_id point_alarm.try(:point_id)
    json.comment point_alarm.try(:comment)

    if point_alarm.try(:state).present?
      type = (point_alarm.try(:alarm_type) == "alarm" ?  (point_alarm.try(:state) > 0) : nil)
      json.type type unless type.nil?
    end
  end
end