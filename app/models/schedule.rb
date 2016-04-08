class Schedule

  # for PUE point's history value
  # Schedule.point_history
  def self.point_history
    points = Point.where(name: "PUE")
    points.each do |point|
      device = Device.find_by_id point.device_id
      item = MultiJson.load($redis.lindex "pue_#{device.room.id}", 0)
      datetime = DateTime.parse(item['datetime']).to_i
      if ((point.created_at.to_i - datetime) / 3600) > 1
        $redis.lpush "pue_#{device.room.id}", {datetime: point.created_at.strftime("%Y-%m-%d %H:00:00"), value: point.value }.to_json
      end
      # caches = ($redis.hget "eagle_schedule_point_history", point.point_index) || (["0"]*24).join("-")
      # values = caches.split("-")
      # values << (point.value || "0")
      # values.shift
      # $redis.hset "eagle_schedule_point_history", point.point_index, values.join("-")
    end
  end

  # for point classify
  # Schedule.point_classify
  def self.point_classify
    start_time = DateTime.now.strftime("%Q").to_i
    Point.all.each do |point|
      meaning = point.try(:meaning)
      if meaning =~ /\p{Han}/
        puts "meaning is #{meaning}"
        if ["分", "合"].include? meaning
          point.tag_list.add "status_type"
        else
          point.tag_list.add "alarm_type"
        end
      else
        point.tag_list.add "number_type"
      end
      point.save
    end
    end_time = DateTime.now.strftime("%Q").to_i
    puts "Schedule.point_classify time is #{end_time-start_time}"
  end
end
