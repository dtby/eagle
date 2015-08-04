class CreatePointStates < ActiveRecord::Migration
  def change
    create_table :point_states do |t|

      t.timestamps null: false
    end
  end
end
