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

FactoryGirl.define do
  factory :exclude_system do
    show false
system nil
  end

end
