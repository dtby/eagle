json.devices @devices do |device|
  json.id device.try(:id)
  json.name device.try(:name)

  if @point_values.present?
    points = @point_values[device.try(:id)]
    next unless points.present?
    json.points points do |name, value|
      logger.info "name is #{name}, value is #{value}"
      json.set! name, value
    end
  end
end