# == Schema Information
#
# Table name: systems
#
#  id         :integer          not null, primary key
#  sys_name   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe System, type: :model do
end
