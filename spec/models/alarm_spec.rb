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
#

require 'rails_helper'

RSpec.describe Alarm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
