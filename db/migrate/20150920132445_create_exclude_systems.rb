class CreateExcludeSystems < ActiveRecord::Migration
  def change
    create_table :exclude_systems do |t|
      t.boolean :show
      t.references :system, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
