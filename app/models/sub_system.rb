# == Schema Information
#
# Table name: sub_systems
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  system_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sub_systems_on_system_id  (system_id)
#

class SubSystem < ActiveRecord::Base
  belongs_to :system
  has_many :menus, as: :menuable, dependent: :destroy
  has_many :patterns, dependent: :destroy
  has_many :devices, through: :patterns

  after_update :send_notification, if: "name_changed?"
  after_create :send_notification

  DefaultPartial = {
    "UPS系统" => "ups",
    "电量仪系统" => "electricity",
    "空调系统" => "air",
    "温湿度系统" => "temp",
    "漏水系统" => "leak",
    "消防系统" => "fire",
  }

  def self.get_name id
    $redis.hget "sub_system_name_cache", id
  end
  
  def send_notification
    $redis.hset "sub_system_name_cache", self.id, self.name
  end
end
