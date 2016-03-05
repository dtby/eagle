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
#
# Indexes
#
#  index_attachments_on_room_id  (room_id)
#
# Foreign Keys
#
#  fk_rails_18d9b5ec37  (room_id => rooms.id)
#

FactoryGirl.define do
  factory :attachment do
    image "MyString"
tag "MyString"
room nil
  end

end
