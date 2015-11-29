module BaseHelper
  def point_value(point_name, points, exclude_points)
    return "---" if exclude_points.present? && exclude_points.include?(point_name) 
    points[point_name]
  end


  def circle_color(value)
    if value == "0"
      "green"
    elsif value == "1"
      "red"
    end
  end
end
