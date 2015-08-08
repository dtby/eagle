require 'rails_helper'

RSpec.describe AnalogPoint, type: :model do
  it { should have_many :analog_alarms }
  it { should have_many :point_states }
end
