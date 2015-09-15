# == Schema Information
#
# Table name: digital_alarms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DigitalAlarm < ActiveRecord::Base
  self.table_name = "cos" 
  self.abstract_class = true
  establish_connection "dap".to_sym
end
