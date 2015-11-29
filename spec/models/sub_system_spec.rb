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

require 'rails_helper'

RSpec.describe SubSystem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
