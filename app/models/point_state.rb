# == Schema Information
#
# Table name: ptsts
#
#  PointID   :integer          default(0), not null
#  ValueType :integer          default(0), not null
#  Status    :string(64)
#  Confirm   :string(64)
#  Flag      :boolean          default(FALSE)
#  ADate     :date
#  ATime     :time
#

class PointState < ActiveRecord::Base
  self.table_name = "ptsts"

  belongs_to :analog_point, class_name: AnalogPoint, :foreign_key => :PointID
  belongs_to :digital_point, class_name: DigitalPoint, :foreign_key => :PointID
end
