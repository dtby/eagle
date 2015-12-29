class CreateAlarmHistories < ActiveRecord::Migration
  def change
    create_table :alarm_histories do |t|
      t.integer :state
      t.references :point, index: true, foreign_key: true
      t.datetime :checked_time
      t.integer :check_state

      t.timestamps null: false
    end
  end
end
