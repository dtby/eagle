# == Schema Information
#
# Table name: point_states
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PointState < ActiveRecord::Base
  self.table_name = "litop_point"
  self.abstract_class = true
  establish_connection "3droom_db".to_sym

  # 由于源数据库中存在type字段
  # 在rails中，默认用这个字段来处理继承。
  # 为防止报错，添加以下语句
  self.inheritance_column = ""
end
