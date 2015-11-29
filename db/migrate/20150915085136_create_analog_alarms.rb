class CreateAnalogAlarms < ActiveRecord::Migration
  def change
    create_table :analog_alarms do |t|

      t.timestamps null: false
    end
  end
end
