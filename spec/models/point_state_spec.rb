require 'rails_helper'

RSpec.describe PointState, type: :model do
  it { should belong_to :analog_point }
end
