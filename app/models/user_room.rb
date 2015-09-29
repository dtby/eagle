# == Schema Information
#
# Table name: user_rooms
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_rooms_on_room_id  (room_id)
#  index_user_rooms_on_user_id  (user_id)
#

class UserRoom < ActiveRecord::Base
  belongs_to :user
  belongs_to :room

  #保存用户有权限的机房
  def self.save_user_rooms(user, rooms)
  	UserRoom.transaction do
  		rooms.each do |room|
  			UserRoom.create(user_id: user.id, room_id: room)
  		end
  	end
  end
end
