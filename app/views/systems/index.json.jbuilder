json.system @systems do |system|
  json.id system.id
  json.name system.name
  json.sub_system system.sub_systems do |sub_system|
    json.sub_system_name sub_system.name
  end
end