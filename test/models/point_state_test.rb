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

require 'test_helper'

class PointStateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
