class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.string :voltage
      t.string :current
      t.boolean :volt_warning
      t.boolean :cur_warning
      t.string :point_index

      t.timestamps null: false
    end
  end
end
