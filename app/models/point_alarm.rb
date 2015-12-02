# == Schema Information
#
# Table name: point_alarms
#
#  id         :integer          not null, primary key
#  pid        :integer
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  point_id   :integer
#
# Indexes
#
#  index_point_alarms_on_point_id  (point_id)
#
# Foreign Keys
#
#  fk_rails_de15df710f  (point_id => points.id)
#

class PointAlarm < ActiveRecord::Base
  belongs_to :point
end
