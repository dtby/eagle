class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.string :sys_name
      t.string :sub_system
      t.references :room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
