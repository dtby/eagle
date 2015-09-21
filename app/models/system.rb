# == Schema Information
#
# Table name: systems
#
#  id         :integer          not null, primary key
#  sys_name   :string(255)
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_systems_on_room_id  (room_id)
#

class System < ActiveRecord::Base
  belongs_to :room

  has_one :exclude_system, dependent: :destroy
  # has_one :details, dependent: :destroy
  has_many :sub_systems, dependent: :destroy
end
