class CreateExcludeMenus < ActiveRecord::Migration
  def change
    create_table :exclude_menus do |t|
      t.references :room, index: true
      t.references :menuable, polymorphic: true

      t.timestamps null: false
    end

    add_index :exclude_menus, [:menuable_id, :menuable_type]
  end
end
