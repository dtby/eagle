class AddDeviceRefToPoint < ActiveRecord::Migration
  def change
    add_reference :points, :device, index: true, foreign_key: true
  end
end
