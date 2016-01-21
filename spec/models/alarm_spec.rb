# == Schema Information
#
# Table name: alarms
#
#  id            :integer          not null, primary key
#  voltage       :string(255)
#  current       :string(255)
#  volt_warning  :boolean
#  cur_warning   :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  device_name   :string(255)
#  device_id     :integer
#  voltage2      :string(255)
#  current2      :string(255)
#  volt_warning2 :boolean
#  cur_warning2  :boolean
#
# Indexes
#
#  index_alarms_on_device_id  (device_id)
#
# Foreign Keys
#
#  fk_rails_d487d49ffe  (device_id => devices.id)
#

require 'rails_helper'

RSpec.describe Alarm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
