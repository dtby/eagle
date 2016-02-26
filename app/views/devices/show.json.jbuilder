json.extract! @device, :id, :name

if @points.present?
  @points.each do |point|
    if !(@device.try(:name).try(:include?, "机柜")) && (point.name.include? "-")
      name = point.name.split("-").last
    else
      name = point.name
    end
    json.set! name, (point.value||"0")
  end
else
  json.errors "该设备下无点位信息"
end