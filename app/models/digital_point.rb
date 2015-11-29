# == Schema Information
#
# Table name: digital_points
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DigitalPoint < ActiveRecord::Base
  self.table_name = "ptdi"
  self.abstract_class = true
  establish_connection "dap".to_sym
end
