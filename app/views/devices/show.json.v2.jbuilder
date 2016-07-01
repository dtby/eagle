json.extract! @device, :id, :name, :pic

json.number_type @number_type.each do |item|
  json.name item.name.delete('-')
  json.meaning (item.meaning || 0)
  json.color item.color
end
json.status_type @status_type.each do |item|
  json.name item.name.delete('-')
  json.meaning item.meaning
  json.color item.color
end
json.alarm_type @alarm_type.each do |item|
  json.name item.name.delete('-')
  json.meaning item.meaning
  json.color item.color
end
