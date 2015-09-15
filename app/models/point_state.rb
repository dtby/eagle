# == Schema Information
#
# Table name: point_states
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PointState < ActiveRecord::Base
  self.table_name = "litop_point"
  self.abstract_class = true
  establish_connection "3droom_db".to_sym
end
