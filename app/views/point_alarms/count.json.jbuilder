json.room_count @room_count
json.sub_systems @sub_system_count_hash do |sub_system, count|
  json.sub_system_id sub_system.try(:id)
  json.sub_system_name sub_system.try(:name)
  json.sub_system_count count
end