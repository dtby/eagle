class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :name
      t.string :partial_path
      t.references :sub_system, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
