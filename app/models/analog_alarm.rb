# == Schema Information
#
# Table name: alm
#
#  HostA           :string(16)
#  HostB           :string(16)
#  PointID         :integer          default(0)
#  AlarmType       :integer          default(0)
#  Status          :boolean          default(FALSE)
#  AlarmValue      :string(32)
#  ADate           :date
#  ATime           :time
#  AMSecond        :integer          default(0)
#  AckFlag         :boolean          default(FALSE)
#  User            :string(32)
#  Note            :string(255)
#  ConfirmDateTime :datetime
#

class AnalogAlarm < ActiveRecord::Base
  self.table_name = "alm"

  belongs_to :analog_point, class_name: AnalogPoint, :foreign_key => :PointID
end
