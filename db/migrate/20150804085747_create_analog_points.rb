class CreateAnalogPoints < ActiveRecord::Migration
  def change
    create_table :analog_points do |t|

      t.timestamps null: false
    end
  end
end
