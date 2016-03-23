json.extract! @device, :id, :name, :pic

if @points.present?
  ["number_type", "status_type", "alarm_type"].each do |type|
    json.set! type.to_sym do 
      @points.tagged_with(type).to_a.sort_by {|p| p.name[/\d+/].to_i }.each do |point|
        if !(@device.try(:name).try(:include?, "机柜")) && (point.name.include? "-")
          name = point.name.split("-").last
        else
          name = point.name
        end
        json.set! :name, point.name
        json.set! :value, (point.value||"0")
        json.set! :meaning, (point.meaning||"")
        json.set! :color, point.color
      end
    end
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