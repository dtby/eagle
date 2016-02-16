json.devices @devices do |device|
  json.id device.try(:id)
  json.name device.try(:name)

  if @point_values.present?
    points = @point_values[device.try(:id)]
    next unless points.present?
    points.each do |name, value|
      json.set! name, value
    end
  end
end