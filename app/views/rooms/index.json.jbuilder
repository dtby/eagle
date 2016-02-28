if @rooms.present?
  json.rooms @rooms do |room|
    json.name room.try(:name)
    json.id room.try(:id)
  end
end