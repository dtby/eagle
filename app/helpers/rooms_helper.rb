# == Schema Information
#
# Table name: rooms
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  link         :string(255)
#  monitor_link :string(255)
#  area_id      :integer
#
# Indexes
#
#  index_rooms_on_area_id  (area_id)
#
# Foreign Keys
#
#  fk_rails_8a9660ed06  (area_id => areas.id)
#

module RoomsHelper
  Information = Struct.new(
    :room, 
    :sub_room, 
    :system, 
    :sub_system,
    :pattern,
    :device,
    :point,
    :point_index,
    :up_value,
    :down_value)
end
