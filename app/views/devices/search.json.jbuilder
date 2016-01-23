json.devices @devices do |device|
  json.name device.try(:name)
  json.id device.try(:id)
  points = device.points
  next unless points.present?

  json.points points.each do |point|
    json.point_id point.id
    if point.name.include? "-"
      json.point_name point.name.split("-").last
    else
      json.point_name point.name
    end
    json.point_value point.value
  end
end