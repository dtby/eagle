json.extract! @point, :name, :value
json.history @hash do |t, v|
  json.time t
  json.value v
end