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
		create_rooms = rooms.to_a
		pp create_rooms, "create_rooms 11111111111111111111111"
		UserRoom.transaction do
			unless create_rooms.empty?
				create_rooms.each do |room|
					UserRoom.create(user_id: user.id, room_id: room)
				end
			end
		end
	end

	#更新用户有权限的机房
	def self.update_user_rooms(user, rooms)
		old_rooms = self.where(user_id: user.id).pluck(:room_id).collect{ |x| x.to_s }
		new_rooms = rooms.to_a.dup

		#新增机房
		create_rooms = new_rooms - old_rooms
		#应删除的机房
		delete_rooms = old_rooms - new_rooms

		create_rooms.each do |create_room|
			self.create(user_id: user.id, room_id: create_room)
		end

		delete_rooms.each do |delete_room|
			self.where(user_id: user.id, room_id: delete_room).destroy_all
		end
	end
end
