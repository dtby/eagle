# == Schema Information
#
# Table name: admin_rooms
#
#  id         :integer          not null, primary key
#  admin_id   :integer
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_admin_rooms_on_admin_id  (admin_id)
#  index_admin_rooms_on_room_id   (room_id)
#

class AdminRoom < ActiveRecord::Base
  belongs_to :admin
  belongs_to :room

end
