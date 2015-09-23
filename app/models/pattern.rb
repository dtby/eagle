# == Schema Information
#
# Table name: patterns
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  partial_path  :string(255)
#  sub_system_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_patterns_on_sub_system_id  (sub_system_id)
#

class Pattern < ActiveRecord::Base
  belongs_to :sub_system

  # 不同型号对应节点，分组返回数据
  # 返回值：{ group: [ point ] }
  def point_group
    {
      '旁路输入' => ['A组', 'B组', 'C组', 'D组', 'E组'],
      '旁路输出' => ['A组', 'B组', 'C组', 'D组', 'E组'],
      '电池电压' => ['正电压', '负电压', '总电压']
    }
  end
end
