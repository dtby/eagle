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

require 'rails_helper'

RSpec.describe AdminRoom, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
