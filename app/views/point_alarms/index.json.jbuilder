json.total_pages @point_alarms.try(:total_pages) || 1
json.current_page @point_alarms.try(:current_page) || 1

if @point_alarms.present?
  json.alarm_size @point_alarms.total_entries  
  json.point_alarms @point_alarms do |point_alarm|
    json.id point_alarm.try(:id)
    json.device_name point_alarm.try(:device).try(:name)
    json.pid point_alarm.try(:pid)
    json.state point_alarm.try(:state)
    json.created_at point_alarm.try(:created_at).try(:strftime, "%Y-%m-%d %H:%M:%S")
    json.updated_at point_alarm.try(:updated_at).try(:strftime, "%Y-%m-%d %H:%M:%S")
    json.checked_at point_alarm.try(:checked_at).try(:strftime, "%Y-%m-%d %H:%M:%S")
    json.is_checked (point_alarm.try(:is_checked) || false)
    json.point_id point_alarm.try(:point_id)
    json.point_name point_alarm.try(:point).try(:name)
    json.comment point_alarm.try(:comment)
    json.checked_user point_alarm.try(:checked_user) || ""

    type = "开关量告警"
    if (point_alarm.try(:state).present? && point_alarm.alarm_type == "alarm")
      case point_alarm.try(:state) || 0
      when -2
        type = "越下下限"
      when -1
        type = "越下限"
      when  1
        type = "越上限"
      when  2
        type = "越上上限"
      else
        type = "开关量告警"
      end
    end
    json.type type
    json.meaning point_alarm.try(:meaning)
    json.alarm_value point_alarm.try(:alarm_value)
  end
end