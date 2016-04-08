class CreateVirtualPoints < ActiveRecord::Migration
  def change
    create_table :virtual_points do |t|

      t.timestamps null: false
    end
  end
end
