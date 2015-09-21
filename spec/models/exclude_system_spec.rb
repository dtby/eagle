# == Schema Information
#
# Table name: exclude_systems
#
#  id         :integer          not null, primary key
#  show       :boolean
#  system_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_exclude_systems_on_system_id  (system_id)
#

require 'rails_helper'

RSpec.describe ExcludeSystem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
