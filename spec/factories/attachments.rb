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

FactoryGirl.define do
  factory :attachment do
    association :room, name: "room for attachment"

    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'assets', 'test.jpg')) }
    tag "MyString"
  end

end
