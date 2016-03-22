json.systems @systems do |system|
  next unless system.present?
  json.id system.id
  json.name system.name
  json.sub_system (@sub_systems || system.sub_systems) do |sub_system|
    next unless system.sub_systems.include? sub_system
    json.sub_system_name sub_system.name
    json.id sub_system.id
  end
end