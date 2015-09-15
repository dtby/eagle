# == Schema Information
#
# Table name: analog_alarms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AnalogAlarm < ActiveRecord::Base
  self.table_name = "alm"
  self.abstract_class = true
  establish_connection "dap".to_sym
end
