# == Schema Information
#
# Table name: menus
#
#  id            :integer          not null, primary key
#  room_id       :integer
#  menuable_id   :integer
#  menuable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_menus_on_menuable_id_and_menuable_type  (menuable_id,menuable_type)
#  index_menus_on_room_id                        (room_id)
#

class Menu < ActiveRecord::Base
  belongs_to :room
  belongs_to :menuable, polymorphic: true

  # 参数: room,机房；list，菜单［"#{menuable_id}_#{menuable_type}"］］
  def self.update_menus_by_room(room, menus)
  	old_menus = room.menu_to_s
  	add_menus = menus - old_menus
  	delete_menus = old_menus - menus
  	
  	add_menus.each do |m|
  		menuable_id = m.split('_')[0]
  		menuable_type = m.split('_')[1]
  		self.create(room: room, menuable_id: menuable_id, menuable_type: menuable_type)
  	end

  	delete_menus.each do |m|
  		menuable_id = m.split('_')[0]
  		menuable_type = m.split('_')[1]
  		self.where(room: room, menuable_id: menuable_id, menuable_type: menuable_type).destroy_all
  	end
  end
end
