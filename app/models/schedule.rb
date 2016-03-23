class Schedule
  
  # for PUE point's history value
  # Schedule.point_history
  def self.point_history
    points = Point.where(name: "PUE")
    points.each do |point|
      caches = ($redis.hget "eagle_schedule_point_history", point.point_index) || "0-0-0-0-0"
      values = caches.split("-")
      values << (point.value || "0")
      values.shift
      $redis.hset "eagle_schedule_point_history", point.point_index, values.join("-")
    end
  end

end