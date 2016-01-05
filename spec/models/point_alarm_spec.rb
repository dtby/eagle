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
#  is_checked :boolean          default(FALSE)
#
# Indexes
#
#  index_point_alarms_on_point_id  (point_id)
#

require 'rails_helper'

RSpec.describe PointAlarm, type: :model do
end
