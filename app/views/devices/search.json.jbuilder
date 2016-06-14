json.devices @devices do |device|
  json.id device.try(:id)
  json.name device.try(:name)

  json.alarm @device_alarm[device.try(:id)] unless @device_alarm[device.try(:id)].nil?

  json.points @points_value
  
end
