# == Schema Information
#
# Table name: ptdi
#
#  StationName  :string(64)
#  BayName      :string(64)
#  GroupName    :string(64)
#  PointName    :string(64)
#  PointID      :integer          default(0), not null, primary key
#  ValueType    :integer          default(0)
#  InitialValue :string(32)
#  TripPointID  :string(32)
#  ClosePointID :string(32)
#  COS          :integer          default(0)
#  RSName       :string(64)
#  Comment      :string(255)
#  InvertStatus :boolean          default(FALSE)
#  AutoFlag     :boolean          default(FALSE)
#  DoubleFlag   :boolean          default(FALSE)
#  Class        :string(32)
#  TravelName   :string(16)
#  OffName      :string(16)
#  OnName       :string(16)
#  InvalidName  :string(16)
#  CCFlag       :boolean          default(FALSE)
#  PMSFlag      :boolean          default(FALSE)
#  RealFlag     :boolean          default(FALSE)
#

class DigitalPoint < ActiveRecord::Base
  self.table_name = "ptdi"

  has_many :digital_alarms, :class_name => 'DigitalAlarm', :foreign_key => :PointID
  has_many :point_states, :class_name => 'PointState', :foreign_key => :PointID
end
