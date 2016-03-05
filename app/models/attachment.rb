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

class Attachment < ActiveRecord::Base
  belongs_to :room

  default_scope {order('id desc')}

  validates :room_id, presence: true
  validates :image, presence: true, on: :new
  validates :tag, presence: true

  mount_uploader :image, ImageUploader
end
