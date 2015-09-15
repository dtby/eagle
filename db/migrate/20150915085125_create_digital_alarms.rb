class CreateDigitalAlarms < ActiveRecord::Migration
  def change
    create_table :digital_alarms do |t|

      t.timestamps null: false
    end
  end
end
