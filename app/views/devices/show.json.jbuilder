json.extract! @device, :id, :name

if @points.present?
  json.points @points.each do |point|
    if point.name.include? "-"
      name = point.name.split("-").last
    else
      name = point.name
    end
    json.set! name, point.value
  end
else
  json.errors "该设备下无点位信息"
end