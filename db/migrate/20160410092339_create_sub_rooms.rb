class CreateSubRooms < ActiveRecord::Migration
  def change
    create_table :sub_rooms do |t|
      t.string :name
      t.references :room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
