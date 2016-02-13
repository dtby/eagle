json.devices @devices do |device|
  json.id device.try(:id)
  json.name device.try(:name)

  points = @point_values[device.try(:id)]
  next unless points.present?
  json.points points do |name, value|
    json.set! name, value
  end
end