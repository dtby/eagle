json.devices @devices do |device|
  json.name device.try(:name)
  json.id device.try(:id)
end