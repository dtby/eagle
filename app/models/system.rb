# == Schema Information
#
# Table name: systems
#
#  id         :integer          not null, primary key
#  sys_name   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class System < ActiveRecord::Base
  # has_one :details, dependent: :destroy
  has_many :sub_systems, dependent: :destroy # 所有三级菜单
  has_many :menus, as: :menuable, dependent: :destroy

  def name
    sys_name
  end
end
