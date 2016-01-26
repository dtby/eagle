json.devices @datas do |name, points|
  json.device_name name
  json.points points do |point|
    json.set! point.name, point.value
  end
end
