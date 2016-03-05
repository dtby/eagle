# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  image      :string(255)
#  tag        :string(255)
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#
# Indexes
#
#  index_attachments_on_room_id  (room_id)
#
# Foreign Keys
#
#  fk_rails_18d9b5ec37  (room_id => rooms.id)
#

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
