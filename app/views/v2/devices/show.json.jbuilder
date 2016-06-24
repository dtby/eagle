json.extract! @device, :id, :name, :pic

["number_type", "status_type"].each do |type|
  json.set! type.to_sym do 
    json.array! @points.tagged_with(type).to_a.sort_by {|p| p.name[/\d+/].to_i }.each do |point|
      if !(@device.try(:name).try(:include?, "机柜")) && (point.name.include? "-")
        name = point.name.split("-").last
      else
        name = point.name
      end
      json.name name
      json.value (point.value||"0")
      json.meaning (point.meaning||"")
      json.color point.color
    end
  end
end

if @alarms.blank?
  json.alarm_type @points.each do |point|
    if !(@device.try(:name).try(:include?, "机柜")) && (point.name.include? "-")
      name = point.name.split("-").last
    else
      name = point.name
    end
    json.name name
    json.value (point.value||"0")
    json.meaning (point.meaning||"")
    json.color point.color
  end  
else
  json.alarm_type @alarms.each do |k, v|
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
end
