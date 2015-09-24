module Admin::PatternsHelper
  def point_show?(exclude_points, group, point)
    eps = exclude_points[group] || []
    !eps.include?(point)
  end
end
