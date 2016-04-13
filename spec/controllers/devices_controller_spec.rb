# == Schema Information
#
# Table name: devices
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  pattern_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :integer
#  pic_path    :string(255)
#  state       :boolean          default(FALSE)
#  sub_room_id :integer
#
# Indexes
#
#  index_devices_on_pattern_id  (pattern_id)
#  index_devices_on_room_id     (room_id)
#

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do

end
