json.extract! @device, :id, :name, :pic_path

if @points.present?
  json.points @points.each do |point|
    if !(@device.try(:name).try(:include?, "机柜")) && (point.name.include? "-")
      name = point.name.split("-").last
    else
      name = point.name
    end
    json.name name
    json.value (point.value||"0")
  end
else
  json.points_errors "该设备下无点位信息"
end


if @alarms.present?
  json.alarms @alarms.each do |k, v|
    json.name k
    json.value v
    case @alarm_types[k] || 0
    when -2
      json.type "越下下限"
    when -1
      json.type "越下限"
    when  1
      json.type "越上限"
    when  2
      json.type "越上上限"
    else
      json.type "开关量告警"
    end
  end
else
  json.alarms_errors "该设备下无告警信息"
end