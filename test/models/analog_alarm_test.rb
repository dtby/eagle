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

require 'test_helper'

class AnalogAlarmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
