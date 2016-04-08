# == Schema Information
#
# Table name: virtual_points
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VirtualPoint < ActiveRecord::Base
  self.table_name = "ptpsd"
  self.abstract_class = true
  establish_connection "dap".to_sym
end
