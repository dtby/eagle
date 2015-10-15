# == Schema Information
#
# Table name: devices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  pattern_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :integer
#
# Indexes
#
#  index_devices_on_pattern_id  (pattern_id)
#  index_devices_on_room_id     (room_id)
#

class Device < ActiveRecord::Base
  scope :by_room, ->(room_id) { where("room_id = ?", room_id) }

  belongs_to :pattern
  belongs_to :room

  has_many :points, dependent: :destroy
end
