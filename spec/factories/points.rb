# == Schema Information
#
# Table name: points
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  point_index :string(255)
#  device_id   :integer
#  state       :boolean          default(TRUE)
#  point_type  :integer
#  max_value   :string(255)
#  min_value   :string(255)
#
# Indexes
#
#  index_points_on_device_id  (device_id)
#
# Foreign Keys
#
#  fk_rails_d6f3cdbe9a  (device_id => devices.id)
#

FactoryGirl.define do
  factory :point do
    
  end

end
