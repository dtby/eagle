json.devices @devices do |device|
  json.id device.try(:id)
  json.name device.try(:name)

  json.alarm @device_alarm[device.try(:id)] unless @device_alarm[device.try(:id)].nil?

  if @point_values.present?
    points = @point_values[device.try(:id)]
    next unless points.present?
    json.array!(@points) do |name, value|
      json.name name
      json.value value
    end
  end
  
end