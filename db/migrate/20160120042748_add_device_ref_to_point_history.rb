class AddDeviceRefToPointHistory < ActiveRecord::Migration
  def change
    add_reference :point_histories, :device, index: true, foreign_key: true
  end
end
