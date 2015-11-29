# == Schema Information
#
# Table name: analog_points
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AnalogPoint < ActiveRecord::Base
  self.table_name = "ptai"
  self.abstract_class = true
  establish_connection "dap".to_sym
end
