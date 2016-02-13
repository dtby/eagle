json.devices @devices do |device|
  json.id device.try(:id)
  json.name device.try(:name)

  if @point_values.present?
    points = @point_values[device.try(:id)]
    logger.info "@point_values is #{@point_values.inspect}"
    next unless points.present?
    json.points points do |name, value|
      json.set! name, value
    end
  end
end