json.devices @devices do |device|
  json.id device.try(:id)
  json.name device.try(:name)

  json.alarm device.is_alarm?

  json.points device.main_point_value
  
end
