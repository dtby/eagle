class Schedule
  
  # for PUE point's history value
  # Schedule.point_history
  def self.point_history
    points = Point.where(name: "PUE")
    points.each do |point|
      caches = ($redis.hget "eagle_schedule_point_history", point.point_index) || (["0"]*24).join("-")
      values = caches.split("-")
      values << (point.value || "0")
      values.shift
      $redis.hset "eagle_schedule_point_history", point.point_index, values.join("-")
    end
  end

  # for point classify
  # Schedule.point_classify
  def self.point_classify
    start_time = DateTime.now.strftime("%Q").to_i
    Point.all.each do |point|
      meaning = point.meaning
      if meaning
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
    logger.info "Schedule.point_classify time is #{end_time-start_time}"
  end
end