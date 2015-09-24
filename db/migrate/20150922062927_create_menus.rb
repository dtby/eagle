class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.references :room, index: true, foreign_key: true
      t.references :menuable, polymorphic: true

      t.timestamps null: false
    end

    add_index :menus, [:menuable_id, :menuable_type]
  end
end
