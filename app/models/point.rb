# == Schema Information
#
# Table name: points
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  pattern_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_points_on_pattern_id  (pattern_id)
#

class Point < ActiveRecord::Base
  belongs_to :pattern
end
