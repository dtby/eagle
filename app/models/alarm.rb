# == Schema Information
#
# Table name: alarms
#
#  id           :integer          not null, primary key
#  voltage      :string(255)
#  current      :string(255)
#  volt_warning :boolean
#  cur_warning  :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  device_name  :string(255)
#  device_id    :integer
#
# Indexes
#
#  index_alarms_on_device_id  (device_id)
#
# Foreign Keys
#
#  fk_rails_d487d49ffe  (device_id => devices.id)
#

class Alarm < ActiveRecord::Base
  belongs_to :device
end
