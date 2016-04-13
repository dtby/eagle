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

require 'rails_helper'

RSpec.describe Room, type: :model do
end
