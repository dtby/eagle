# == Schema Information
#
# Table name: systems
#
#  id         :integer          not null, primary key
#  sys_name   :string(255)
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_systems_on_room_id  (room_id)
#

require 'rails_helper'

RSpec.describe System, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
