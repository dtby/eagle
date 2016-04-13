# == Schema Information
#
# Table name: sub_rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sub_rooms_on_room_id  (room_id)
#

class SubRoom < ActiveRecord::Base
  belongs_to :room

  has_many :devices, dependent: :destroy
end
