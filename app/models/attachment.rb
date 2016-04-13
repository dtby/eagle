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

class Attachment < ActiveRecord::Base
  belongs_to :room

  default_scope {order('id desc')}

  scope :enabled, -> {
    where("deleted_at is null")
  }

  validates :room_id, presence: true
  validates :image, presence: true
  validates :tag, presence: true

  mount_uploader :image, ImageUploader
end
