json.devices @devices do |device|
  json.id device.try(:id)
  json.name device.try(:name)
  json.points @point_values[device.try(:id)] do |name, value|
    json.set! name, value
  end
end