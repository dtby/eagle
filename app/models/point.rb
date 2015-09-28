# == Schema Information
#
# Table name: points
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  pattern_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  point_index :string(255)
#
# Indexes
#
#  index_points_on_pattern_id  (pattern_id)
#

class Point < ActiveRecord::Base
  belongs_to :pattern

  # 取得节点的value
  def value
    ps = PointState.where(pid: point_index.to_i).try(:last)
    ps.try(:value)
  end
end
