# == Schema Information
#
# Table name: cos
#
#  HostA           :string(16)
#  HostB           :string(16)
#  PointID         :integer          default(0)
#  Status          :integer          default(0)
#  ADate           :date
#  ATime           :time
#  AMSecond        :integer          default(0)
#  AckFlag         :boolean          default(FALSE)
#  User            :string(32)
#  Note            :string(255)
#  ConfirmDateTime :datetime
#

class DigitalAlarm < ActiveRecord::Base
  self.table_name = "cos"
end
