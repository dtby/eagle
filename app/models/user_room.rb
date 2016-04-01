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
# Foreign Keys
#
#  fk_rails_3ee87d0014  (user_id => users.id)
#  fk_rails_577ff954d1  (room_id => rooms.id)
#

class UserRoom < ActiveRecord::Base
	establish_connection "#{Rails.env}".to_sym
	
	belongs_to :user
	belongs_to :room

	#保存用户有权限的机房
	def self.save_user_rooms(user, rooms)
		create_rooms = rooms.to_a
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

	# 保存有权限操作此机房的用户
	def self.room_belongs_to_users(room, users)
		add_users = users.to_a
		UserRoom.transaction do
			unless add_users.empty?
				add_users.each do |user|
					UserRoom.create(room_id: room.id, user_id: user)
				end
			end
		end
	end

	#更新有权限操作次机房的新用户
	def self.update_room_users(room, users)
		old_users = self.where(room_id: room.id).pluck(:user_id).collect{ |x| x.to_s }
		new_users = users.to_a.dup

		#新增用户
		create_users = new_users - old_users
		#应删除的机房
		delete_users = old_users - new_users

		create_users.each do |create_user|
			self.create(room_id: room.id, user_id: create_user)
		end

		delete_users.each do |delete_user|
			self.where(room_id: room.id, user_id: delete_user).destroy_all
		end
	end
end
