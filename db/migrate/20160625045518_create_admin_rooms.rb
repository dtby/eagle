class CreateAdminRooms < ActiveRecord::Migration
  def change
    create_table :admin_rooms do |t|
      t.references :admin, index: true
      t.references :room, index: true
      
      t.timestamps null: false
    end
  end
end
