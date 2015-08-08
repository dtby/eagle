# == Schema Information
#
# Table name: ptai
#
#  StationName      :string(64)
#  BayName          :string(64)
#  GroupName        :string(64)
#  PointName        :string(64)
#  PointID          :integer          default(0), not null, primary key
#  LowPointID       :integer          default(0)
#  RaisePointID     :integer          default(0)
#  RSName           :string(64)
#  Comment          :string(255)
#  ValueType        :integer          default(0)
#  InitialValue     :string(32)
#  RecFlag          :boolean          default(FALSE)
#  LogDB            :integer          default(0)
#  LogDBPar         :float(24)        default(1.0)
#  AlarmLimitFlag   :boolean          default(FALSE)
#  AlarmRatioFlag   :boolean          default(FALSE)
#  AlarmHoldingTime :integer          default(0)
#  UUpValue         :string(32)
#  UpValue          :string(32)
#  DnValue          :string(32)
#  DDnValue         :string(32)
#  UUpName          :string(64)
#  UpName           :string(64)
#  DnName           :string(64)
#  DDnName          :string(64)
#  Ratio            :float(24)        default(0.0)
#  RatioName        :string(64)
#  MinValue         :string(32)
#  MaxValue         :string(32)
#  CCFlag           :boolean          default(FALSE)
#  PMSFlag          :boolean          default(FALSE)
#  RealFlag         :boolean          default(FALSE)
#

class AnalogPoint < ActiveRecord::Base
  self.table_name = "ptai"
  has_many :analog_alarms, :class_name => 'AnalogAlarm', :foreign_key => :PointID
  has_many :point_state, :class_name => 'PointState', :foreign_key => :PointID
end
