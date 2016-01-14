# == Schema Information
#
# Table name: alarms
#
#  id           :integer          not null, primary key
#  voltage      :string(255)
#  current      :string(255)
#  volt_warning :boolean
#  cur_warning  :boolean
#  point_index  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Alarm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
