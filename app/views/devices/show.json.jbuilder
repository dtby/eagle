json.extract! @device, :id, :name

if @points.present?
  json.points @points.each do |point|
    json.point_id point.id
    if point.name.include? "-"
      json.point_name point.name.split("-").last
    else
      json.point_name point.name
    end
    json.point_value point.value
  end
else
  json.errors "该设备下无点位信息"
end