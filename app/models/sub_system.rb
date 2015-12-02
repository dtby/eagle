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
# Foreign Keys
#
#  fk_rails_52e604f8a0  (system_id => systems.id)
#

class SubSystem < ActiveRecord::Base
  belongs_to :system
  has_many :menus, as: :menuable, dependent: :destroy
  has_many :patterns, dependent: :destroy
  has_many :devices, through: :patterns
end
