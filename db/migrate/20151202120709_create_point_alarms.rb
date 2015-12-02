class CreatePointAlarms < ActiveRecord::Migration
  def change
    create_table :point_alarms do |t|
      t.integer :pid
      t.integer :state

      t.timestamps null: false
    end
  end
end
