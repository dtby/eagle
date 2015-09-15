class CreateDigitalPoints < ActiveRecord::Migration
  def change
    create_table :digital_points do |t|

      t.timestamps null: false
    end
  end
end
